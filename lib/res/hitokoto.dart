const hitokoto = [
  '与众不同的生活方式很累人呢，因为找不到借口',
  '面对就好，去经历就好。',
  '将愿望倾入不愿忘却的回忆中',
  '努力是不会背叛自己的，虽然梦想有时会背叛自己',
  '用你的笑容去改变这个世界，别让这个世界改变了你的笑容',
  '我有在反省，但我不后悔',
  '世界上没有一个人能代替另一个人。',
  '我的腿让我停下，可是心却不允许我那么做',
  '可是就算我们通一千次短信，我们各自的心，大概也只会相互靠近一厘米吧',
  '勇气，就是即便害怕也会去做',
  '只要有想见面的人，自己就不再是孤单一人',
  '我很好奇！',
  '在走廊上跌倒会流鼻血，在人生中跌倒会流眼泪。',
  '已经无法回到过去了。也不知道将来会是什么模样。',
  '相信十年后的八月，我们还会相遇。',
  '看到的感受到的永远都不会消失永远都不会忘记，与各种各样的相遇一同永存。',
  '我们走过风走过雨，就是没能走进彼此的内心。',
  '即使从梦中醒来，还会有回忆留下。',
  '悲伤教会了我喜悦。',
  '梦总是有会醒来的时候，不会醒的梦总有一天会变成悲伤。',
  '真正让我难受的，大概是因为让你看到如此狼狈的自己。',
  '真正重要的东西，总是没有的人比拥有的人清楚。',
  '我们所过的每个平凡的日常，也许就是连续发生的奇迹',
  '要是因为烦恼很痛苦，就选择了轻松的选项，将来一定会后悔',
  '心，可是很重的',
  '人生在世何其痛苦，所以咖啡至少该甜一点',
  '每个人的生命都由秒来计算，因为你永远都不知道下一秒会发生什么。',
  '为什么要担心？如果努力了，担心不会让结果变得更好。',
  '爱欲于人，犹如执炬，逆风而行，必有烧手之患',
  '我们是独立的个体，却不是孤独的存在。',
  '幸运的人一生都在被童年治愈，不幸的人一生都在治愈童年。',
  '只要结局有可能变好，我们就不能胆怯，就像只要能看到一点蓝天，就不能对天气绝望。',
  '无论我们能活多久，我们能够享受的只有无法分割的此刻，此外别无其他。',
  '认真的思索，真诚的明辨是非，有这种态度，大概可算是善良吧。',
  '多少事，从来急，天地转，光阴迫，一万年太久，只争朝夕。',
  '物质决定意识，意识反作用于物质',
  '因为痛苦太有价值，因为回忆太珍贵，所以我们更要继续往前走。',
  '愿生活不太拥挤，愿笑容不必刻意。愿孤独不再长久，愿碎镜终有重圆。',
  '世界之大为何我们相遇，难道是缘分，难道是天意。',
  '我们生活在阴沟里，但有人依然仰望星空。',
  '宇宙是蚂蚁的梦。',
  '时间不在于你拥有多少，而在于你怎样使用。',
  '要保持希望在每天清晨太阳升起。',
  '我在最没有能力的年纪，遇见了最想照顾一生的人。',
  '搞怪的不是红绿灯，而是我数不清的犹豫。',
  '醉后不知天在水，满船清梦压星河。',
  '人生得意须尽欢，莫让金樽空对月。',
  '云想衣裳花想容，春风拂槛露华浓。',
  '疏影横斜水清浅，暗香浮动月黄昏。',
  '仰天大笑出门去，我辈岂是蓬蒿人。',
  '溪云初起日沉阁，山雨欲来风满楼。',
  '劝君莫惜金缕衣，劝君惜取少年时。',
  '最是人间留不住，朱颜辞镜花辞树。',
  '当人们做不到一些事情的时候，他们会对你说你也同样不能。',
  '爱你所爱，行你所行，听从你心，无问西东。',
  '你现在的气质里，藏着你走过的路，读过的书和爱过的人。',
  '我希望在20出头的生命里，做一件到八十岁想起来都还会微笑的事。',
  '时光会把你雕刻成你应有的样子。',
  '冬天之所以那么冷是为了告诉大家身边人的温暖有多重要。',
  '你需要找出面对明天的力量。',
  '面对无知的嘲笑，我只能为他们默哀。',
  '既然忘不掉，就把它留在心中，让时间去冲淡它。',
  '我曾经失落失望失掉所有方向，直到看见平凡才是唯一的答案。',
  '合抱之木，生于毫末；九层之台，起于累土；千里之行，始于足下。',
  '世间所有的相遇，都是久别重逢。',
  '斜晖脉脉水悠悠,肠断白频洲.',
  '不要跟过去的自己比，要期待未来的自己，珍爱现在的自己。',
  '我知道这个世上有人在等我，尽管我不知道我在等谁。当因为这样，我每天都很快乐。'
  '我从远方赶来，恰巧你们也在。',
  'Write the code, Change the world.',
  '生活不止眼前的苟且，还应该有诗和远方的田野。',
  '善恶终有报，天道好轮回。不信抬头看，苍天饶过谁。',
  '年轻时最大的财富，不是你的青春，不是你的美貌，也不是你有充沛的精力，而是你有犯错误的机会。',
  '闾阎扑地，钟鸣鼎食之家；舸舰迷津，青雀黄龙之舳。',
  '鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。',
  '螃蟹在剥我的壳，笔记本在写我。漫天的我落在枫叶上雪花上。而你在想我。',
  '一个人至少拥有一个梦想，有一个理由去坚强。心若没有栖息的地方，到哪里都是在流浪。',
];

