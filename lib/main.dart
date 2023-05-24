import 'package:flutter/material.dart';
import 'package:flutter_application_meal/neis_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic mealList = const Text('검색하세요');

  void showCal() async {
    final dt = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023, 3, 2),
      lastDate: DateTime(2023, 12, 30),
    );

    if (dt == null) return; // 사용자가 취소 버튼을 눌렀을 경우

    String fromDate = dt.start.toString().split(' ')[0].replaceAll('-', '');
    String toDate = dt.end.toString().split(' ')[0].replaceAll('-', '');

    var neisApi = NeisApi();
    var meals = await neisApi.getMeal(fromDate: fromDate, toDate: toDate);

    setState(() {
      if (meals.isEmpty) {
        mealList = const Center(
          child: Text('결과가 없습니다'),
        );
      } else {
        mealList = ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(meals[index]['MLSV_YMD']),
              subtitle: Text(
                meals[index]['DDISH_NM'].toString().replaceAll('<br/', '\n'),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: meals.length,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 검색'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text('날짜를 선택하고 식단을 확인하세요.'),
          const SizedBox(height: 20),
          Expanded(child: mealList),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCal,
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
