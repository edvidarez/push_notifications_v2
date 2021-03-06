import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:flutter_apns/apns.dart';
import 'package:push_notifications_v2/alert_object.dart';
import 'package:push_notifications_v2/notification_object.dart';

void main() => runApp(MyApp());
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  print("Message $message");
  if (message.containsKey('data')) {
    print('on message $message');
    final dynamic messageData = message['data'];
    final dynamic data = messageData['data'];
    final dynamic alert = data["alert"];
    final title = alert["title"];
    final body = alert["body"];
    print("data $data");
    _showNotificationWithDefaultSound(
      title,
      body,
    );
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("notification $notification");
  }

  // Or do other work.
}

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future _showNotificationWithDefaultSound(String title, String msj) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.example.push_notifications_V2',
      'channel name',
      'channel description',
      importance: Importance.Max,
      priority: Priority.High);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true, presentBadge: true, presentSound: true);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(
    0,
    title,
    msj,
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final connector = createPushConnector();

  @override
  void initState() {
    firebaseCloudMessagingListeners();
    _configureLocalNotifications();
    initParse();
    // String s =
    //     '''{"alert":{"body":"Bob wants to play poker","title":"Game Request"}}''';
    // AlertObject alertObj = AlertObject.fromJson(json.decode(s));
    // print("$alertObj");
    super.initState();
  }

  Future<void> initParse() async {
    // Initialize parse
    print("Initializing Parse");
    await Parse()
        .initialize("myAppId", "https://2728b454.ngrok.io/parse", debug: true);

    final ParseResponse response = await Parse().healthCheck();

    if (response.success) {
      print("Success Helth check");
      initInstallation();
    } else {
      print("Failed Helth check");
    }
  }

  Future<void> initInstallation() async {}

  void firebaseCloudMessagingListeners() async {
    await initParse();
    final ParseInstallation installation =
        await ParseInstallation.currentInstallation();

    if (Platform.isIOS) {
      connector.configure(
          onLaunch: (Map<String, dynamic> message) async {
            print('on launch $message');
          },
          onResume: (Map<String, dynamic> message) async {
            print('on resume $message');
          },
          onMessage: (Map<String, dynamic> message) async {
            print('on message $message');
            final dynamic messageData = message['data'];
            final dynamic data = messageData['data'];
            final dynamic alert = data["alert"];
            final title = alert["title"];
            final body = alert["body"];
            print("data $data");
            _showNotificationWithDefaultSound(
              title,
              body,
            );
          },
          onBackgroundMessage: myBackgroundMessageHandler);
      connector.requestNotificationPermissions();
      connector.token.addListener(() async {
        print('Token ${connector.token.value}');
        installation.set("deviceToken", connector.token.value);
        final ParseResponse response = await installation.create();
        print(response);
      });
    } else {
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          final dynamic messageData = message['data'];
          print(messageData);
          final dynamic data = messageData['data'];
          print(data);
          AlertObject alertObj = AlertObject.fromJson(json.decode(data));
          print("${alertObj}");

          final title = alertObj.alert.title;
          final body = alertObj.alert.body;
          print("data $data");
          _showNotificationWithDefaultSound(
            title,
            body,
          );
        },
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );
      String token = await _firebaseMessaging.getToken();
      print('Token ${token}');
      installation.set("deviceToken", token);
      final ParseResponse response = await installation.create();
      print(response);
    }

    //_firebaseMessaging.subscribeToTopic("all");
  }

  void _configureLocalNotifications() {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android, iOS);
    _flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String payload) {
    debugPrint("payload : $payload");
    // open App
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
