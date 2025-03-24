import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ExperienceData extends Equatable {
  ExperienceData({
    required this.name,
    this.description,
    this.logo,
  });

  final String name;
  late String? description;
  late String? logo;
  @override
  List<Object?> get props => [
    name,
    description,
    logo
  ];

}