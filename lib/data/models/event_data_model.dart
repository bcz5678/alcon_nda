import 'dart:core';
import 'package:equatable/equatable.dart';

class EventData extends Equatable{
  EventData({
    required this.eventDate,
    required this.eventCongressConvention,
    required this.eventCity,
    required this.eventState,
    this.eventDisplayName,
  });

  final DateTime eventDate;
  final String eventCongressConvention;
  final String eventCity;
  final String eventState;
  late String? eventDisplayName;

  @override
  List<Object?> get props => [
    eventDate,
    eventCongressConvention,
    eventCity,
    eventState,
    eventDisplayName,
  ];
}