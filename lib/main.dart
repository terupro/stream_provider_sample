import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coming Out',
      theme: ThemeData(
        textTheme: const TextTheme(bodyText2: TextStyle(fontSize: 45)),
      ),
      home: HomePage(),
    );
  }
}

final streamProvider = StreamProvider.autoDispose<int?>((ref) {
  Stream<int?> getNumbers() async* {
    await Future.delayed(const Duration(seconds: 1));
    yield 3;

    await Future.delayed(const Duration(seconds: 1));
    yield 2;

    await Future.delayed(const Duration(seconds: 1));
    yield 1;

    await Future.delayed(const Duration(seconds: 1));
    yield 0;
  }

  return getNumbers();
});

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(streamProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Coming Out')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          ref.refresh(streamProvider);
        },
      ),
      body: Center(
        child: asyncValue.when(
          error: (err, _) => Text(err.toString()),
          loading: () => const CircularProgressIndicator(),
          data: (data) => Text(data.toString()),
        ),
      ),
    );
  }
}
