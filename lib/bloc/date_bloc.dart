import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  final _pageDateGenerate = 60;

  @override
  DateState get initialState => InitialDateState();

  @override
  Stream<DateState> mapEventToState(
    DateEvent event,
  ) async* {
    final currentState = state;
    if (event is GenerateEvent) {
      if (currentState is InitialDateState) {
        final dates = await _fetchDates(0);
        yield GenerateDate(dates: dates);
      }
      if (currentState is GenerateDate) {
        print("load next : ${event.pageDate}");
        final dates = await _fetchDates(event.pageDate);
        yield GenerateDate(dates: dates);
      }
    }
  }

  Future<List<DateTime>> _fetchDates(int page) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(_pageDateGenerate, (index) {
      DateTime date =
          DateTime.now().add(Duration(days: index + page * _pageDateGenerate));
      return date;
    });
  }
}
