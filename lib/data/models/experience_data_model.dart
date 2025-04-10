import 'package:equatable/equatable.dart';

class ExperienceData extends Equatable {
  ExperienceData({
    required this.name,
    this.description,
  });

  final String name;
  late String? description;

  
  @override
  List<Object?> get props => [
    name,
    description,
  ];

}