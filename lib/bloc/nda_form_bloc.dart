import 'dart:convert';
import 'dart:typed_data';

import 'package:alcon_flex_nda/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:alcon_flex_nda/data/data.dart';

part 'nda_form_event.dart';
part 'nda_form_state.dart';

class NDAFormBloc extends Bloc<NDAFormEvent, NDAFormState> {
  NDAFormBloc() : super(NDAFormState.initial()) {
    on<NDAGetEventData>(onNDAGetEventData);
    on<NDAGetClientData>(onNDAGetClientData);
    on<NDAGetAllExperiencesData>(onNDAGetAllExperiencesData);
    on<NDAFormFullNameChanged>(onNDAFormFullNameChanged);
    on<NDAFormTitleChanged>(onNDAFormTitleChanged);
    on<NDAFormAddress1Changed>(onNDAFormAddress1Changed);
    on<NDAFormAddress2Changed>(onNDAFormAddress2Changed);
    on<NDAFormCityChanged>(onNDAFormCityChanged);
    on<NDAFormStateAbbrChanged>(onNDAFormStateAbbrChanged);
    on<NDAFormZipcodeChanged>(onNDAFormZipcodeChanged);
    on<NDAFormDetailsSubmitted>(onNDAFormDetailsSubmitted);
    on<NDAFormExperiencesSubmitted>(onNDAFormExperiencesSubmitted);
    on<NDAFormExperienceSelected>(onNDAFormExperienceSelected);
    on<NDAFormExperienceUnselected>(onNDAFormExperienceUnselected);
    on<NDAFormAddSignature>(onNDAFormAddSignature);
  }

  ///
  /// SECTION - Getting initial DataSets for display and signing
  ///

  void onNDAGetEventData(
      NDAGetEventData event,
      Emitter<NDAFormState> emit
      ) {

    EventData _eventdata = getEventDataFromLocal();

    emit(
        state.copyWith(
            eventData: _eventdata
        )
    );
  }

  void onNDAGetClientData(
      NDAGetClientData event,
      Emitter<NDAFormState> emit
      ) {

    ClientData clientData = getClientDataFromLocal();

    emit(
        state.copyWith(
          clientData: clientData,
        )
    );
  }

  void onNDAGetAllExperiencesData(
      NDAGetAllExperiencesData event,
      Emitter<NDAFormState> emit
      ) {

    List<ExperienceData> experiencesList = getGetAllExperiencesDataFromLocal();

    emit(
        state.copyWith(
          experiencesData: experiencesList,
        )
    );
  }

  ///
  /// SECTION - Form Inputs tracking and validation
  ///

  void onNDAFormFullNameChanged(
      NDAFormFullNameChanged event,
      Emitter<NDAFormState> emit
      ) {

    final fullName = FullNameInput.dirty(event.fullName);

    emit(
      state.copyWith(
        fullNameInput: fullName,
      )
    );
  }

  void onNDAFormTitleChanged(
      NDAFormTitleChanged event,
      Emitter<NDAFormState> emit
      ) {
    final title = TitleInput.dirty(event.title);

    emit(
        state.copyWith(
          titleInput: title,
        )
    );
  }

  void onNDAFormAddress1Changed(
      NDAFormAddress1Changed event,
      Emitter<NDAFormState> emit
      ) {
    final address_1 = Address1Input.dirty(event.address_1);

    emit(
        state.copyWith(
          address1Input: address_1,
        )
    );
  }

  void onNDAFormAddress2Changed(
      NDAFormAddress2Changed event,
      Emitter<NDAFormState> emit
      ) {
    final address_2 = Address2Input.dirty(event.address_2);

    emit(
        state.copyWith(
          address2Input: address_2,
        )
    );
  }

  void onNDAFormCityChanged(
      NDAFormCityChanged event,
      Emitter<NDAFormState> emit
      ) {
    final city = CityInput.dirty(event.city);

    emit(
        state.copyWith(
          cityInput: city,
        )
    );
  }

  void onNDAFormStateAbbrChanged(
      NDAFormStateAbbrChanged event,
      Emitter<NDAFormState> emit
      ) {
    final state_abbr = StateAbbrInput.dirty(event.state_abbr);

    emit(
        state.copyWith(
          stateAbbrInput: state_abbr,
        )
    );
  }

  void onNDAFormZipcodeChanged(
      NDAFormZipcodeChanged event,
      Emitter<NDAFormState> emit
      ) {
    final zipcode  = ZipcodeInput.dirty(event.zipcode );

    emit(
        state.copyWith(
          zipcodeInput: zipcode,
        )
    );
  }

  ///
  /// SECTION - Page Step submissions and moving to next page
  ///


  void onNDAFormDetailsSubmitted(
      NDAFormDetailsSubmitted event,
      Emitter<NDAFormState> emit
      ) {


    var guestData = state.guestData;
    guestData?.fullName = state.fullNameInput!.value.toString();
    guestData?.title = state.titleInput!.value.toString();
    guestData?.address_1 = state.address1Input!.value.toString();
    guestData?.address_2 = state.address2Input!.value.toString();
    guestData?.city = state.cityInput!.value.toString();
    guestData?.state = state.stateAbbrInput!.value.toString();
    guestData?.zipcode = state.zipcodeInput!.value.toString();

    emit(
        state.copyWith(
          formStepCurrent: NDAFormStep.addExperiences,
          guestData: guestData,
        )
    );
  }

  void onNDAFormExperiencesSubmitted(
      NDAFormExperiencesSubmitted event,
      Emitter<NDAFormState> emit
      ) {


    var guestData = state.guestData;
    guestData?.experiencesSelected = [];
    guestData?.experiencesSelected = state.selectedExperiences!;

    emit(
        state.copyWith(
          formStepCurrent: NDAFormStep.signature,
          guestData: guestData,
        )
    );
  }

  void onNDAFormExperienceSelected(
      NDAFormExperienceSelected event,
    Emitter<NDAFormState> emit
    ) {

    List<ExperienceData>? _selectedExperiences = state.selectedExperiences;

    _selectedExperiences?.add(event.experience);

    emit(
        state.copyWith(
          selectedExperiences: _selectedExperiences,
        )
    );
  }

  void onNDAFormExperienceUnselected(
      NDAFormExperienceUnselected event,
      Emitter<NDAFormState> emit
    ) {

    List<ExperienceData>? _selectedExperiences = state.selectedExperiences;

    _selectedExperiences?.remove(event.experience);

    emit(
        state.copyWith(
          selectedExperiences: _selectedExperiences,
        )
    );
  }

  void onNDAFormAddSignature(
      NDAFormAddSignature event,
      Emitter<NDAFormState> emit
      ) {

    var _guestData = state.guestData;

    _guestData?.signature = event.signature;

    emit(
        state.copyWith(
          guestData: _guestData,
        )
    );
  }


  EventData getEventDataFromLocal() {
    var response = jsonDecode(eventJsonData);

    return EventData(
      eventDisplayName: response["eventDisplayName"] as String,
      eventDate: response["eventDate"] != "" ? DateTime.parse(response["eventDate"]) : DateTime.now(),
      eventState: response["eventState"] as String,
      eventCity: response["eventCity"] as String,
      eventCongressConvention: response["eventCongressConvention"] as String,
    );
  }

  List<ExperienceData> getGetAllExperiencesDataFromLocal() {
    List<ExperienceData> returnList = [];
    var response = jsonDecode(experiencesJsonData);

    for (var item in response["data"]) {
      returnList.add(
          ExperienceData(
            name: item["name"] as String,
            description: item["description"] as String,
            logo: item["logo"] as String,
          )
      );
    }
    return returnList;
  }

  ClientData getClientDataFromLocal() {
    var response = jsonDecode(clientJsonData);

    return ClientData(
      clientBySignature: response["clientBySignature"],
      clientName: response["clientName"],
      clientTitle: response["clientTitle"],
      clientDate: response["clientDate"] != "" ? DateTime.parse(response["clientDate"]) : DateTime.now(),
    );
  }
}


