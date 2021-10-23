#!/usr/bin/env dart

/// 使用示例
/// 请在使用前，在本项目根目录创建[countly_config]文件，按行填入URL和KEY。
/// `./make.dart build android`编译Android 64bit版本
/// `./make.dart build android 32`编译Android 32bit版本
/// `./make.dart build ios`编译iOS 64bit版本

import 'dart:convert';
import 'dart:io';

const appName = 'CustedNG';
const buildDataClassPath = 'lib/res/build_data.dart';
const countlyConfigClassPath = 'lib/config/countly.dart';

Encoding getCommandLineEncoding() {
  return Encoding.getByName("UTF-8");
}

Future<int> getGitCommitCount() async {
  final encoding = getCommandLineEncoding();
  final result = await Process.run('git', ['log', '--oneline'],
      stdoutEncoding: encoding, stderrEncoding: encoding);
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.isNotEmpty)
      .length;
}

Future<void> generateCountlyConfig() async {
  final configs = await File('countly_config').readAsLines();
  if (configs.length < 2) {
    throw Exception('''No Countly config file. 
          Please add URL and KEY by lines to 
          file countly_config in project root dir.''');
  }

  final data = {
    'url': configs[0],
    'key': configs[1],
  };

  await writeStaicConfigFile(data, 'CountlyConfig', countlyConfigClassPath);
}

Future<void> writeStaicConfigFile(
    Map<String, dynamic> data, String className, String path) async {
  final buffer = StringBuffer();
  buffer.writeln('// This file is generated by ./make.dart');
  buffer.writeln('');
  buffer.writeln('class $className {');
  for (var entry in data.entries) {
    final type = entry.value.runtimeType;
    final value = json.encode(entry.value);
    buffer.writeln('  static const $type ${entry.key} = $value;');
  }
  buffer.writeln('}');
  await File(path).writeAsString(buffer.toString());
}

Future<int> getGitModificationCount() async {
  final result =
      await Process.run('git', ['ls-files', '-mo', '--exclude-standard']);
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.isNotEmpty)
      .length;
}

Future<String> getFlutterVersion() async {
  final result = await Process.run('flutter', ['--version'],
      runInShell: true, stdoutEncoding: getCommandLineEncoding());
  return (result.stdout as String);
}

Future<Map<String, dynamic>> getBuildData() async {
  final data = {
    'name': appName,
    'build': await getGitCommitCount(),
    'engine': await getFlutterVersion(),
    'buildAt': DateTime.now().toString(),
    'modifications': await getGitModificationCount(),
  };
  return data;
}

String jsonEncodeWithIndent(Map<String, dynamic> json) {
  final encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}

Future<void> updateBuildData() async {
  print('Updating BuildData...');
  final data = await getBuildData();
  print(jsonEncodeWithIndent(data));
  await writeStaicConfigFile(data, 'BuildData', buildDataClassPath);
}

void flutterRun(String mode) {
  Process.start('flutter', ['run', '--$mode'],
      mode: ProcessStartMode.inheritStdio, runInShell: true);
}

void flutterBuild(
    String source, String target, bool isAndroid, bool is32Bit) async {
  final startTime = DateTime.now();
  final build = await getGitCommitCount();

  final args = [
    'build',
    isAndroid ? 'apk' : 'ipa',
    '--target-platform=android-arm${is32Bit ? "" : 64}',
    '--build-number=$build',
    '--build-name=1.0.$build'
  ];
  if (!isAndroid) args.removeAt(2);
  print('Building with args: ${args.join(' ')}');
  final buildResult = await Process.run('flutter', args, runInShell: true);
  final exitCode = buildResult.exitCode;

  if (exitCode == 0) {
    target = target.replaceFirst('build', build.toString());
    print('Copying from $source to $target');
    if (await File('release').exists()) {
      await Directory('release').create();
    }
    await File(source).copy(target);
    print('Done.');
  } else {
    print(buildResult.stderr.toString());
    print('\nBuild failed with exit code $exitCode');
  }
  final endTime = DateTime.now();
  print('Spent time: ${endTime.difference(startTime).toString()}');
}

void flutterBuildIOS() async {
  await flutterBuild('./build/ios/iphoneos/$appName.app',
      './release/${appName}_build.app', false, false);
}

void flutterBuildAndroid(bool is32Bit) async {
  await flutterBuild('./build/app/outputs/flutter-apk/app-release.apk',
      './release/${appName}_build_Arm${is32Bit ? "" : 64}.apk', true, is32Bit);
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('No action. Exit.');
    return;
  }

  final command = args[0];

  await generateCountlyConfig();

  switch (command) {
    case 'run':
      if (args.length > 1) {
        await updateBuildData();
        return flutterRun(args[1]);
      }
      return flutterRun('');
    case 'build':
      if (args.length > 1) {
        await updateBuildData();
        if (args[1] == 'android' || args[1] == 'harmony') {
          return flutterBuildAndroid(args.last == '32');
        } else if (args[1] == 'ios') {
          return flutterBuildIOS();
        }
        print('unkonwn build arg: ${args[1]}');
      }
      return;
    default:
      print('Unsupported command: $command');
      return;
  }
}
