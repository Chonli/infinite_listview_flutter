import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Infinite List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _fetchDates(int pageNumber) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(30, (index) {
      DateTime date =
          DateTime.now().add(Duration(days: index + (30 * pageNumber)));
      return {
        'date': '$index - ${DateFormat('dd-MM-yyyy').format(date)}',
        'dayofweek': DateFormat('EEEE').format(date),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(itemBuilder: (context, pageNumber) {
          return FutureBuilder(
            future: this._fetchDates(pageNumber),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                case ConnectionState.done:
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var pageData = snapshot.data;

                    return this._buildPage(pageData);
                  }
                  break;
              }
            },
          );
        }));
  }

  Widget _buildPage(List page) {
    return ListView(
        shrinkWrap: true,
        primary: false,
        children: page.map((dateInfo) {
          return ListTile(
            title: Text(dateInfo['date']),
            subtitle: Text(dateInfo['dayofweek']),
          );
        }).toList());
  }
}
