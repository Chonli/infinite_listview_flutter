import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/bloc/bloc.dart';
import 'package:infinite_list/bloc/date_bloc.dart';
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
      home: BlocProvider(
          builder: (context) => DateBloc(),
          child: MyHomePage(title: 'Infinite List')),
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
  List<DateTime> _listDates = [];
  bool _isList = true;
  bool _isLoading = false;
  ScrollController _scrollController;
  DateBloc _dateBloc;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _dateBloc = BlocProvider.of<DateBloc>(context);
    _dateBloc.add(GenerateEvent(DateTime.now()));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    print("onScroll $maxScroll $currentScroll");
    if (!_isLoading && (maxScroll - currentScroll <= 200.0)) {
      print("load next");
      _isLoading = true;
      _dateBloc.add(GenerateEvent(_listDates.last.add(Duration(days: 1))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(_isList ? Icons.view_module : Icons.view_list),
              onPressed: () {
                setState(() {
                  _isList = !_isList;
                });
              },
            )
          ],
        ),
        body: _buildGridView(context));
  }

  Widget _buildGridView(BuildContext context) {
    return BlocBuilder<DateBloc, DateState>(builder: (context, state) {
      if (state is InitialDateState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is GenerateDate) {
        _isLoading = false;
        if (_listDates.isEmpty || _listDates.last.isBefore(state.dates.first))
          _listDates.addAll(state.dates);
        if (_listDates.isEmpty) {
          return Center(
            child: Text('Empty result'),
          );
        }
        print("receive ${state.dates.length}");
        return CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                crossAxisCount: _isList ? 1 : 3,
                childAspectRatio: _isList ? 4 : 2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return GridTile(
                      child: Card(
                          color: _isWeekend(_listDates[index])
                              ? Colors.green
                              : Colors.blue,
                          child: Center(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                Text(
                                    '${DateFormat('dd-MM-yyyy').format(_listDates[index])}'),
                                Text(DateFormat('EEEE')
                                    .format(_listDates[index])),
                              ]))));
                },
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                addSemanticIndexes: true,
                childCount: _listDates.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      }
    });
  }

  bool _isWeekend(DateTime dt) {
    return dt.weekday == 7 || dt.weekday == 6;
  }
}
