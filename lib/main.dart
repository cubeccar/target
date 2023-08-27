
//Login Screen with validation
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:ui_web' as ui;
// import 'dart:html';
import 'package:target/data.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:target/widget/mydetails.dart';
import 'package:window_size/window_size.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() {
  setupWindow();
  // ui.platformViewRegistry
  //     .registerViewFactory('example', (_) => DivElement()..innerText = 'Hello, HTML!');
  runApp(const MyApp());
}

const double windowWidth = 480;
const double windowHeight = 854;

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
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> items = ['January', 'February', 'March', 'April', 'May'];

  late final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
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
            //     //When the child is tappedchildren: <Widget>[FlatButton(

            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    const  Login()),
              );
             },
            );
          },
        ),
      ),

     );

    // );
  }
}