import 'package:equatable/equatable.dart';

class EventData extends Equatable{
  EventData({
    required this.eventDate,
    required this.eventCongressConvention,
    required this.eventCity,
    required this.eventState,
    this.eventDisplayName,
    this.eventWelcomeParagraph,
  });

  final DateTime eventDate;
  final String eventCongressConvention;
  final String eventCity;
  final String eventState;
  late String? eventDisplayName;
  late String? eventWelcomeParagraph;

  @override
  List<Object?> get props => [
    eventDate,
    eventCongressConvention,
    eventCity,
    eventState,
    eventDisplayName,
    eventWelcomeParagraph,
  ];
}