
//Login Screen with validation
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  runApp(MyApp());
}

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Infinite List');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  final List<String> items = ['January', 'February', 'March', 'April', 'May'];

  // This widget is the root of your application.


  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const title = 'My awesome App';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
          actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            //     //When the child is tapped
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    MyDetails(items[index])),
              );
             },
            );
          },
        ),
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const MyDetails(),
      },

    );
  }
}


class MyDetails extends StatefulWidget {
  final String month;
  const MyDetails(this.month, {super.key});

  @override
  State<MyDetails> createState() => _MyDetailsState();
}

class _MyDetailsState extends State<MyDetails> {
  List<MySalesMonth> chartData = [];

  Future loadSalesData() async {
    final String jsonString = await getJsonFromAssets();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(MySalesMonth.fromJson(i));
    }
  }

  Future<String> getJsonFromAssets() async {
    return await rootBundle.loadString('assets/data.json');
  }
  @override
  void initState() {
    // loadSalesData();
    checkLoginStatus();
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Details Page';
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(                                              //Text('You selected $month')
            child: FutureBuilder(
                future: getJsonFromAssets(),
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    return SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        title: ChartTitle(text: 'Half yearly sales analysis'),
                        series: <ChartSeries<MySalesMonth, String>>[
                          LineSeries<MySalesMonth, String>(
                              dataSource: chartData,
                              xValueMapper: (MySalesMonth sales, _) => sales.month,
                              yValueMapper: (MySalesMonth sales, _) => sales.sales
                            // dataLabelSettings: const DataLabelSettings(isVisible: true))

                          )
                        ]);
                  } else {
                    return Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: 100,
                        width: 400,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('retrieving JSON DATA...',
                                  style: TextStyle(fontSize: 20.0)),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator(
                                  semanticsLabel: 'Retrieving JSON DATA',
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Colors.blueAccent),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }

            )
        )
    );

  }
}

class MySalesMonth {
  MySalesMonth(this.month, this.sales);

  final String month;
  final double sales;

  factory MySalesMonth.fromJson(Map<String, dynamic> parsedJson) {
    return MySalesMonth(parsedJson['month'].toString(),
      parsedJson['sales'],
    );
  }
}
