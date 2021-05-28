import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/user_tab/custed_header.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:custed2/ui/widgets/select_view.dart';
import 'package:custed2/ui/widgets/setting_item.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UseTabState();
}

class _UseTabState extends State<UserTab> with AutomaticKeepAliveClientMixin {
  final setting = locator<SettingStore>();
  List<Color> widgetColors = [];
  final custed = CustedService();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<UserProvider>(context);

    if (user.isBusy) return PlaceholderWidget(isActive: true);
    return _buildUserTab(context);
  }

  Widget _buildUserTab(BuildContext context) {
    return Scaffold(
        appBar: NavBar.material(
          context: context,
          leading: Container(),
          middle: NavbarText('设置'),
        ),
        body: _buildSetting());
  }

  Widget _buildSetting() {

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CustedHeader(),
          SizedBox(height: 10.0),
          Text('课表'),
          SizedBox(height: 10.0),
          SettingItem(
            title: '将课表设置为首页',
            isShowArrow: false,
            rightBtn: buildSwitch(context, setting.useScheduleAsHome),
          ),
          SettingItem(
            title: '课表隐藏周末',
            isShowArrow: false,
            rightBtn: buildSwitch(context, setting.scheduleHideWeekend),
          ),
          SettingItem(
            title: '显示非当前周课程',
            isShowArrow: false,
            rightBtn: buildSwitch(context, setting.showInactiveLessons),
          ),
          SizedBox(height: 10.0),
          Text('主题'),
          SizedBox(height: 10.0),
          SettingItem(
            title: '课表主题',
            isShowArrow: false,
            rightBtn: _showMenu(context),
          ),
          SettingItem(
            title: 'App强调色',
            isShowArrow: false,
            rightBtn: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: _buildAppColorPreview(),
            ),
          ),
          SettingItem(
            title: '黑暗模式',
            isShowArrow: false,
            rightBtn: _buildDarkModeRadio(),
          ),
          // SettingItem(
          //   title: '启动时自动更新课表',
          //   titleStyle: settingTextStyle,
          //   isShowArrow: false,
          //   rightBtn: buildSwitch(
          //       context, setting.autoUpdateSchedule),
          // ),
          ExpandChild(
            arrowColor: resolveWithBackground(context),
            icon: Icons.keyboard_arrow_down,
            expandArrowStyle: ExpandArrowStyle.both,
            collapsedHint: '更多设置',
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Text('更多'),
                SizedBox(height: 10.0),
                SettingItem(
                  title: '绩点不计选修',
                  isShowArrow: false,
                  rightBtn:
                      buildSwitch(context, setting.dontCountElectiveCourseGrade),
                ),
                SettingItem(
                  title: '持续自动更新天气',
                  isShowArrow: false,
                  rightBtn: buildSwitch(context, setting.autoUpdateWeather),
                ),
                SizedBox(height: 10.0),
                Text('Beta设置(未开放)'),
                SizedBox(height: 10.0),
                SettingItem(
                  title: '推送上课通知',
                  isShowArrow: false,
                  rightBtn: buildSwitch(
                    context, 
                    setting.pushNotification,
                    func: (v) => sendSetting2Backend(v)
                  ),
                ),
                !BuildMode.isRelease
                    ? SettingItem(
                        title: '桌面课表颜色',
                        isShowArrow: false,
                        rightBtn: _buildColorRow(),
                      )
                    : Container(),
                    ],
                  ),
          ),
          SizedBox(height: 40.0)
        ],
      ),
    );
  }

  Widget _buildAppColorPreview() {
    final nowAppColor = setting.appPrimaryColor.fetch();
    return GestureDetector(
      child: ClipOval(
        child: Container(
          color: Color(setting.appPrimaryColor.fetch()),
          height: 27,
          width: 27,
        ),
      ),
      onTap: () => _showAppColorPicker(Color(nowAppColor)),
    );
  }

  List<String> themeName = [
    '梵高·星空', '霓虹·浅粉', '故宫·口红', 
    '夏日·薄荷', '中式·传统', '蒙克·尖叫'
  ];

  Widget _showMenu(BuildContext context) {
  return PopupMenuButton<int>(
    child: Padding(
      child: Row(
        children: [
          Text(themeName[setting.scheduleTheme.fetch()]),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
      padding: EdgeInsets.fromLTRB(0, 11, 10, 0),
    ),
    itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
      SelectViewText('梵高·星空', 0),
      SelectViewText('霓虹·浅粉', 1),
      SelectViewText('故宫·口红', 2),
      SelectViewText('夏日·薄荷', 3),
      SelectViewText('中式·传统', 4),
      SelectViewText('蒙克·尖叫', 5),
    ],
    onSelected: (int idx) {
      setting.scheduleTheme.put(idx);
      setState(() {});
    });
  }

  void sendSetting2Backend(bool v) async {
    final suc = await custed.setPushScheduleNotification(v);
    if (suc) {
      print('set enable schedule notification success');
      return;
    }
    print('set disable schedule notification failed');
  }

  void _showColorPicker(Color selected, int index) {
    showRoundDialog(
      context,
      '选择颜色',
      MaterialColorPicker(
          shrinkWrap: true,
          onColorChange: (Color color) {
            widgetColors[index] = color;
          },
          selectedColor: selected),
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('取消')
        ),
        TextButton(
          onPressed: () async {
            final colorInt = widgetColors[index].value;
            final colorString =
                widgetColors[index].toString().substring(8, 16);
            final suc = await HomeWidget.saveWidgetData<String>(
                'color$index', colorString);
            if (index == 0) {
              setting.homeWidgetColor1.put(colorInt);
            } else {
              setting.homeWidgetColor2.put(colorInt);
            }
            print('set custom widget color successlly? $suc');
            setState(() {});
            Navigator.of(context).pop();
          },
          child: Text('确定')
        ),
      ]
    );
  }

  Widget _buildColorRow() {
    widgetColors.add(Color(setting.homeWidgetColor1.fetch()));
    widgetColors.add(Color(setting.homeWidgetColor2.fetch()));
    return Container(
      height: 46,
      width: 73,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildColorCircle(widgetColors[0], 0),
          SizedBox(width: 3),
          _buildColorCircle(widgetColors[1], 1),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color, int index) {
    return GestureDetector(
      child: ClipOval(
        child: Container(
          color: color,
          height: 27,
          width: 27,
        ),
      ),
      onTap: () => _showColorPicker(color, index),
    );
  }

  void _showAppColorPicker(Color selected) {
    showRoundDialog(
      context,
      '选择颜色',
      MaterialColorPicker(
        shrinkWrap: true,
        onColorChange: (Color color) async {
          setting.appPrimaryColor.put(color.value);
          final suc = await custed.sendThemeData(color.toString());
          if (suc) print('send theme data successfully: $color');
        },
        selectedColor: selected
      ),
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('取消')
        ),
        TextButton(
          onPressed: () async {
            final dark = setting.darkMode.fetch();
            setting.darkMode.put(dark);
            if (isBrightColor(Color(setting.appPrimaryColor.fetch()))) {
              showSnackBar(context, '当前设置的颜色过浅\n不会应用至高亮字、按钮、开关等');
            }
            setState(() {});
            Navigator.of(context).pop();
          },
          child: Text('确定')
        ),
      ]
    );
  }

  Widget _buildDarkModeRadio() {
    final color = MaterialStateProperty.all(resolveWithBackground(context));
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('自动'),
        Radio(
          value: 0,
          fillColor: color,
          groupValue: setting.darkMode.fetch(),
          onChanged: _onSelection),
        Text('开'),
        Radio(
          value: 1,
          fillColor: color,
          groupValue: setting.darkMode.fetch(),
          onChanged: _onSelection),
        Text('关'),
        Radio(
          value: 2,
          fillColor: color,
          groupValue: setting.darkMode.fetch(),
          onChanged: _onSelection)
      ],
    );
  }

  void _onSelection(int index) {
    if (index == 0) {
      showSnackBar(context, '自动模式仅在Android 10+或iOS 13+有效');
    }
    final setting = locator<SettingStore>();
    setting.darkMode.put(index);
  }

  @override
  bool get wantKeepAlive => true;
}
