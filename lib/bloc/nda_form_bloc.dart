import 'dart:typed_data';

import 'package:alcon_flex_nda/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';

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

  }

  void onNDAGetClientData(
      NDAGetClientData event,
      Emitter<NDAFormState> emit
      ) {

  }

  void onNDAGetAllExperiencesData(
      NDAGetAllExperiencesData event,
      Emitter<NDAFormState> emit
      ) {

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
   return EventData(
     eventDisplayName: "American Academy of Ophthalmology",
     eventDate: DateTime.now(),
     eventState: 'llinois',
     eventCity: 'Chicago ',
     eventCongressConvention: 'American Academy of Ophthalmology [October 1-3]',
   );
  }
}


