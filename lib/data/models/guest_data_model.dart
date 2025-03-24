import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class GuestData extends Equatable {
  GuestData({
    this.fullName,
    this.title,
    this.eventsAdded,
    this.signature,
    this.termsChecked,
  });

  late String? fullName;
  late String? title;
  late List<String>? eventsAdded;
  late Uint8List? signature;
  late bool? termsChecked;




  @override
  List<Object?> get props => [
    fullName,
    title,
    eventsAdded,
    signature,
    termsChecked,
  ];

}