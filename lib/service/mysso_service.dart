import 'dart:io';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/data/models/mysso_profile.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/webview/webview_login.dart';
import 'package:html/parser.dart' show parse;

class MyssoService extends CatService {
  static const baseUrl = 'https://mysso.cust.edu.cn';
  static const loginUrl = '$baseUrl/cas/login';

  static String parseValue(String value) {
    // just handle string case for now.
    // [xxx] -> xxx
    if (value == null) return null;
    if (value.startsWith('[') && value.endsWith(']')) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  final sessionExpirationTest = RegExp(r'(用户登录|登录后可|微信扫码|账号密码)');
  final loginSuccessTest = RegExp(r'(登录成功|成功登录|Log In Successful|进入校园门户)');

  Future<CatLoginResult<String>> login({bool force = false}) async {
    if (force) clearCookieFor(baseUrl.uri);

    final loginService = 'https://portal.cust.edu.cn/custp/shiro-cas';
    final loginUrlWithService = '$loginUrl?service=$loginService';

    final loginPageData = await get(
      loginUrlWithService,
      maxRedirects: 0,
    );

    if (loginPageData.statusCode.isWithin(300, 399) &&
        loginPageData.headers['location'].contains(loginService)) {
      print('Mysso Manual Login Success');
    }

    final context = locator<AppProvider>().ctx;
    final ok = await WebviewLogin.begin(context, back2PrePage: true);
    if (ok) {
      return CatLoginResult.ok();
    }

    return CatLoginResult.failed();
  }

  Future<MyssoProfile> getProfile() async {
    final document = parse((await xRequest('GET', loginUrl.uri)).body);
    final custId = document.querySelector('strong > span')?.innerHtml ??
        document.querySelector('p > strong')?.innerHtml ??
        '用户';

    final data = Map.fromIterables(
      document.querySelectorAll('td > kbd > span').map((e) => e.innerHtml),
      document.querySelectorAll('td > code > span').map((e) => e.innerHtml),
    );
    return MyssoProfile(
      custId: custId,
      name: parseValue(data['CN']),
      surname: parseValue(data['SN']),
      cookie: parseValue(data['cookie']),
      memberOf: parseValue(data['MEMBEROF']),
      pass: parseValue(data['PASS']),
      college: parseValue(data['college']),
      grade: int.tryParse(parseValue(data['grade'])),
      sno: parseValue(data['sno']),
    );
  }

  Future<String> getFrontPage([String url = loginUrl]) async {
    final resp = await this.get(url);
    return resp.body;
  }

  Future<String> getTicket(String service) async {
    final response = await xRequest(
      'GET',
      Uri.parse('$baseUrl/cas/login?service=$service'),
      maxRedirects: 0,
    );

    if (response.isRedirect) {
      final location = response.headers[HttpHeaders.locationHeader];
      return Uri.parse(location).queryParameters['ticket'];
    }

    return null;
  }

  Future<String> getTicketForPortal() =>
      getTicket('https://portal.cust.edu.cn/custp/shiro-cas');

  Future<String> getTicketForWebvpn() =>
      getTicket('https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1');

  Future<String> getTicketForWrdvpn() =>
      getTicket('http://wwwn.cust.edu.cn/wengine-auth/login?cas_login=true');

  Future<String> getTicketForJw() =>
      getTicket('https://jwgl.cust.edu.cn/welcome');

  Future<String> getTicketForIecard() =>
      getTicket('http://iecard.cust.edu.cn:8080/ias/prelogin?sysid=FWDT');

  Future<String> getTicketForNetdisk() =>
      getTicket('http://tx.cust.edu.cn/ucsso/shiro-cas');
}
