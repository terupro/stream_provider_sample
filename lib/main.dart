import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // ProviderScopeでラップする
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Count Down',
      theme: ThemeData(
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 50)),
      ),
      home: HomePage(),
    );
  }
}

// StreamProviderの作成 (データを非同期で断続的に取得する)
final streamProvider = StreamProvider<dynamic>((ref) {
  Stream<dynamic> getNumbers() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield 'Are You Ready?';

    await Future.delayed(const Duration(seconds: 1));
    yield 3;

    await Future.delayed(const Duration(seconds: 1));
    yield 2;

    await Future.delayed(const Duration(seconds: 1));
    yield 1;

    await Future.delayed(const Duration(seconds: 1));
    yield '💥';
  }

  return getNumbers();
});

// StreamProviderを作成すると「AsyncValue」オブジェクトを生成できる
//「AsyncValue」は非同期通信の通信中、通信終了、異常終了処理をハンドリングしてくれるRiverpodの便利な機能のこと

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValueオブジェクトを取得する
    final asyncValue = ref.watch(streamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Count Down')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          // 状態を更新する
          ref.refresh(streamProvider);
        },
      ),
      body: Center(
        child: asyncValue.when(
          error: (err, _) => Text(err.toString()), //エラー時
          loading: () => const CircularProgressIndicator(), //読み込み時
          data: (data) => Text(data.toString()), //データ受け取り時
        ),
      ),
    );
  }
}
