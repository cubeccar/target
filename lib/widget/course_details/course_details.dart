import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
/*
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

*/

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'FLUTTER WEB.\nTHE BASICS',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 80, height: 0.9),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'In this course we will go over the basics of using Flutter Web for website development. Topics will include Responsive Layout, Deploying, Font Changes, Hover Functionality, Modals and more.',
            style: TextStyle(fontSize: 21, height: 1.7),
          ),
          TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.blue),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () =>
                        launchUrl(Uri.parse('/index.html')),
                    child: const Text('Provider Bloc'),
            ),
        ],
      ),
    );
  }
}
