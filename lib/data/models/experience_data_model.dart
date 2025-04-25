import 'package:equatable/equatable.dart';

class ExperienceData extends Equatable {
  ExperienceData({
    required this.name,
    this.dates,
    this.description,
  });

  final String name;
  final String? dates;
  late String? description;

  
  @override
  List<Object?> get props => [
    name,
    dates,
    description,
  ];

}