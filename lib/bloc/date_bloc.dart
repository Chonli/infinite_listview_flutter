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
    if (event is GenerateEvent) {
      final dates = await _fetchDates(event.startDate);
      yield GenerateDate(dates: dates);
    }
  }

  Future<List<DateTime>> _fetchDates(DateTime startDate) async {
    await Future.delayed(Duration(seconds: 1));

    return List.generate(_pageDateGenerate, (index) {
      DateTime date = startDate.add(Duration(days: index));
      return date;
    });
  }
}
