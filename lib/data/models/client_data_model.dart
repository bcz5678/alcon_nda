import 'dart:core';
import 'package:equatable/equatable.dart';

class ClientData extends Equatable{
  ClientData({
    required this.clientBySignature,
    required this.clientName,
    required this.clientTitle,
    required this.clientDate,
  });

  final String clientBySignature;
  final String clientName;
  final String clientTitle;
  final DateTime clientDate;

  @override
  List<Object?> get props => [
    clientBySignature,
    clientName,
    clientTitle,
    clientDate,
  ];
}