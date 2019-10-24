import 'package:equatable/equatable.dart';

abstract class DateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateEvent extends DateEvent {
  final DateTime startDate;

  GenerateEvent(this.startDate);
}
