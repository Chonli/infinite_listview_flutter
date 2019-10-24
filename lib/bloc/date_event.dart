import 'package:equatable/equatable.dart';
import 'package:infinite_list/bloc/bloc.dart';

abstract class DateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateEvent extends DateEvent {
  final int pageDate;

  GenerateEvent(this.pageDate);
}
