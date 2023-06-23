import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';



void main() {
  runApp(MyApp());
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
      ),


      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

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
    loadSalesData();
    super.initState();
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
