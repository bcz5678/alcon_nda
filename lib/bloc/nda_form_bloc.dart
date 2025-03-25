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
    on<NDAFormFullNameChanged>(onNDAFormFullNameChanged);
    on<NDAFormTitleChanged>(onNDAFormTitleChanged);
    on<NDAFormAddress1Changed>(onNDAFormAddress1Changed);
    on<NDAFormAddress2Changed>(onNDAFormAddress2Changed);
    on<NDAFormCityChanged>(onNDAFormCityChanged);
    on<NDAFormStateAbbrChanged>(onNDAFormStateAbbrChanged);
    on<NDAFormZipcodeChanged>(onNDAFormZipcodeChanged);
    on<NDAFormStepSubmitted>(onNDAFormStepSubmitted);
    on<NDAGetEventData>(onNDAGetEventData);
    on<NDAGetClientData>(onNDAGetClientData);
    on<NDAGetAllExperiencesData>(onNDAGetAllExperiencesData);
    on<NDAFormExperienceSelected>(onNDAFormExperienceSelected);
    on<NDAFormExperienceUnselected>(onNDAFormExperienceUnselected);
  }

  void onNDAFormFullNameChanged(
      NDAFormFullNameChanged event,
      Emitter<NDAFormState> emit
      ) {

    final fullName = FullNameInput.dirty(event.fullName);

    emit(
      state.copyWith(
        fullNameInput: fullName,
        fullNameInputValid: Formz.validate([fullName]),
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
          titleInputValid: Formz.validate([title]),
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
          address1InputValid: Formz.validate([address_1]),
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
          address2InputValid: Formz.validate([address_2]),
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
          cityInputValid: Formz.validate([city]),
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
          stateAbbrInputValid: Formz.validate([state_abbr]),
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
          zipcodeInputValid: Formz.validate([zipcode ]),
        )
    );
  }


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

  void onNDAFormStepSubmitted(
      NDAFormStepSubmitted event,
      Emitter<NDAFormState> emit
      ) {

    var guestData = state.guestData;

    guestData?.fullName = state.fullNameInput.toString();
    guestData?.title = state.titleInput.toString();

    emit(
        state.copyWith(
          formStepCurrent: event.nextStep,
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
      clientDate: response["clientDate"],
    );
  }
}


