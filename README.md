# Levons Video Player

对[`video_player`](https://pub.dev/packages/video_player)插件封装了一层控件

### Usage

```dart
class _MyHomePageState extends State<MyHomePage> {
  late final LevonsPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = LevonsPlayerController(
      settings: const LevonsPlayerSettings(title: '测试视频'),
      sourcesMap: {
        '240p': 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4',
        '480p': 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Levons Video Player Example'),
      ),
      body: LevonsPlayerWidget(controller: controller),
    );
  }
}
```

### Feature

- [x] 全屏
- [x] 切换视频源
- [x] 自定义控件
- [x] 调整播放速度
