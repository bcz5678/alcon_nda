import 'dart:convert';
import 'dart:core';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
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


  Uint8List toList() {
    Uint8List returnList;
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

    var jsonString = jsonEncode(jsonData);

    return returnList;
  }




  String? buildExperiencesFormData() {
    String returnData = "";

    for(var index = 0; index < guestData.experiencesSelected!.length; index++){
      returnData  = returnData + "    • ${guestData.experiencesSelected![index]}<br>";
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