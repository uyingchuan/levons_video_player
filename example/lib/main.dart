import 'package:flutter/material.dart';
import 'package:levons_video_player/levons_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final LevonsPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = LevonsPlayerController(
      title: '测试视频',
      sourcesMap: {
        '240p': 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Levons Video Player Example'),
      ),
      body: Column(
        children: [
          VideoPlayerWidget(controller: controller),
        ],
      ),
    );
  }
}
