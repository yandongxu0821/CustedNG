class ScheduleDates {
  static final holidays = {
    // TODO: Update this every YEAR :), previous update at 2025-08-26
    /*
    2025 - 来源：http://m.cyol.com/gb/auto/articles/2024-11/13/content_AjPBLLsvm6.html
    按照上述原则，现将2025年元旦、春节、清明节、劳动节、端午节、中秋节和国庆节放假调休日期的具体安排通知如下。
      一、元旦：1月1日（周三）放假1天，不调休。
      二、春节：1月28日（农历除夕、周二）至2月4日（农历正月初七、周二）放假调休，共8天。1月26日（周日）、2月8日（周六）上班。
      三、清明节：4月4日（周五）至6日（周日）放假，共3天。
      四、劳动节：5月1日（周四）至5日（周一）放假调休，共5天。4月27日（周日）上班。
      五、端午节：5月31日（周六）至6月2日（周一）放假，共3天。
      六、国庆节、中秋节：10月1日（周三）至8日（周三）放假调休，共8天。9月28日（周日）、10月11日（周六）上班。
    */
    DateTime(2025, 1, 1): '元旦',
    DateTime(2025, 4, 4): '清明',
    DateTime(2025, 4, 5): '休',
    DateTime(2025, 4, 6): '休',
    DateTime(2025, 4, 27): '班',
    DateTime(2025, 5, 1): '劳动',
    DateTime(2025, 5, 2): '休',
    DateTime(2025, 5, 3): '休',
    DateTime(2025, 5, 4): '休',
    DateTime(2025, 5, 5): '休',
    DateTime(2025, 5, 31): '端午',
    DateTime(2025, 6, 1): '休',
    DateTime(2025, 6, 2): '休',
    DateTime(2025, 9, 28): '班',
    DateTime(2025, 10, 1): '国庆',
    DateTime(2025, 10, 2): '休',
    DateTime(2025, 10, 3): '休',
    DateTime(2025, 10, 4): '休',
    DateTime(2025, 10, 5): '休',
    DateTime(2025, 10, 6): '中秋',
    DateTime(2025, 10, 7): '休',
    DateTime(2025, 10, 8): '休',
    DateTime(2025, 10, 11): '班',
  };

  static String getHoliday(DateTime dateTime) {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return holidays[dateTime];
  }
}
