import 'dart:convert';
import 'dart:typed_data';

import 'package:alcon_flex_nda/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:alcon_flex_nda/data/data.dart';

part 'nda_form_event.dart';
part 'nda_form_state.dart';

class NDAFormBloc extends Bloc<NDAFormEvent, NDAFormState> {
  NDAFormBloc() : super(NDAFormState.initial()) {
    on<NDAFormFullNameChanged>(onNDAFormFullNameChanged);
    on<NDAFormTitleChanged>(onNDAFormTitleChanged);
    on<NDAFormStepSubmitted>(onNDAFormStepSubmitted);
    on<NDAGetEventData>(onNDAGetEventData);
    on<NDAGetClientData>(onNDAGetClientData);
    on<NDAGetAllExperiencesData>(onNDAGetAllExperiencesData);
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


