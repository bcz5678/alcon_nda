import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:alcon_flex_nda/data/data.dart' show ExperienceData, ClientData, GuestData, EventData;
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class FormDataModel extends Equatable {
  FormDataModel({
    required this.clientData,
    required this.eventData,
    required this.guestData,
  });

  final ClientData clientData;
  final EventData eventData;
  final GuestData guestData;


  List<int> toList() {
    List<int>? returnList;
    String? jsonString;
    List<int>? jsonList;
    var experiencesList = buildExperiencesFormData();

    Map<String, dynamic> jsonData = {
      'effectiveDate': '${DateFormat.MMMMd().format(
          clientData.clientDate)}, ${DateFormat.y().format(
          clientData.clientDate)}'.toUpperCase(),
      'guestFullName': guestData.fullName!.toUpperCase(),
      'guestTitle': guestData.title!.toUpperCase(),
      'address': '${guestData.address_1}${guestData.address_2 != "" ? ", ${guestData.address_2.toString()}, " : ", " }${guestData.city}, ${guestData.state} ${guestData.zipcode}'.toUpperCase(),
      'experiencesList': experiencesList,
      'convention': eventData.eventCongressConvention,
      'state': eventData.eventState,
      'city': eventData.eventCity,
      'signGuestFullName': guestData.fullName,
      'signClientFullName': guestData.fullName,
      'signGuestTitle': guestData.title,
      'signClientTitle': clientData.clientTitle,
      'signGuestDate': DateFormat.yMd().format(DateTime.now()).toString(),
      'signClientDate': '${DateFormat.MMMMd().format(clientData.clientDate)}, ${DateFormat.y().format(clientData.clientDate)}'.toUpperCase(),
    };

    jsonString = jsonEncode(jsonData);
    jsonList = jsonString.codeUnits;
    //returnList = Uint8List.fromList(jsonList);

    return jsonList;
  }

  Map<String, String> toJsonMap() {
    var experiencesList = buildExperiencesFormData();

    Map<String, String> jsonData = {
      'effectiveDate': '${DateFormat.MMMMd().format(
          clientData.clientDate)}, ${DateFormat.y().format(
          clientData.clientDate)}'.toUpperCase(),
      'guestFullName': guestData.fullName!.toUpperCase(),
      'address': '${guestData.address_1}${guestData.address_2 != "" ? ", ${guestData.address_2.toString()}, " : ", " }${guestData.city}, ${guestData.state} ${guestData.zipcode}'.toUpperCase(),
      'experiencesList': experiencesList ?? "",
      'convention': eventData.eventCongressConvention,
      'state': eventData.eventState,
      'city': eventData.eventCity,
      'signGuestFullName': guestData.fullName ?? "",
      'signClientFullName': clientData.clientName ?? "",
      'signGuestTitle': guestData.title ?? "",
      'signClientTitle': clientData.clientTitle,
      'signGuestDate': DateFormat.yMd().format(DateTime.now()).toString(),
      'signClientDate': '${DateFormat.MMMMd().format(clientData.clientDate)}, ${DateFormat.y().format(clientData.clientDate)}'.toUpperCase(),
    };

    return jsonData;
  }





  String? buildExperiencesFormData() {
    String returnData = "";

    for(var index = 0; index < guestData.experiencesSelected!.length; index++){
      returnData  = returnData + "    • ${guestData.experiencesSelected![index]}\n";
    }
    return returnData;
  }

  @override
  List<Object?> get props =>[
    clientData,
    eventData,
    guestData,
  ];
}