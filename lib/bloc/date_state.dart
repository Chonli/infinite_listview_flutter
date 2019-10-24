import 'package:equatable/equatable.dart';

abstract class DateState extends Equatable {
  const DateState();

  @override
  List<Object> get props => [];
}

class InitialDateState extends DateState {}

class GenerateDate extends DateState {
  final List<DateTime> dates;

  const GenerateDate({
    this.dates,
  });

  GenerateDate copyWith({
    List<DateTime> dates,
  }) {
    return GenerateDate(
      dates: dates ?? this.dates,
    );
  }

  @override
  List<Object> get props => [dates];

  @override
  String toString() => 'GenerateDate { dates: ${dates.length}}';
}
