import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:target/data.dart';

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


class MyDetails extends StatefulWidget {


  const MyDetails({super.key});

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
    super.initState();
    loadSalesData();
    // checkLoginStatus();

  }
  //
  // checkLoginStatus() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getString("token") == null) {
  //     if (context.mounted) {
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //               builder: (BuildContext context) => Login()), (
  //           Route<dynamic> route) => false);
  //       //Auth for Firebase
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const title = 'Details Page';
    return Scaffold(
        appBar: AppBar(
          title: const Text(title),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // sharedPreferences.clear();
                // sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()), (Route<dynamic> route) => false);
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.amberAccent)),
            ),
          ],
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
