import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import 'package:alcon_flex_nda/data/data.dart' show ExperienceData;


class GuestData extends Equatable {
  GuestData({
    this.fullName,
    this.title,
    this.address_1,
    this.address_2,
    this.city,
    this.state,
    this.zipcode,
    this.experiencesSelected,
    this.signature,
    this.termsChecked,
  });

  late String? fullName;
  late String? title;
  late String? address_1;
  late String? address_2;
  late String? city;
  late String? state;
  late String? zipcode;
  late List<ExperienceData>? experiencesSelected;
  late Uint8List? signature;
  late bool? termsChecked;


  @override
  List<Object?> get props => [
    fullName,
    title,
    address_1,
    address_2,
    city,
    state,
    zipcode,
    experiencesSelected,
    signature,
    termsChecked,
  ];
}