part of 'nda_form_bloc.dart';

enum NDAFormStep {
  start,
  addExperiences,
  signature,
  submit
}

class NDAFormState extends Equatable{
  NDAFormState({
    required this.formzSubmissionStatus,
    required this.formStepCurrent,
    this.fullNameInput,
    this.titleInput,
    this.fullNameInputValid,
    this.titleInputValid,
    this.guestData,
    this.clientData,
    this.eventData,
    this.experiencesData,
});

  NDAFormState.initial()
      : this(
    formzSubmissionStatus: FormzSubmissionStatus.initial,
    formStepCurrent: NDAFormStep.start,
    fullNameInput: FullNameInput.pure(),
    titleInput: TitleInput.pure(),
    fullNameInputValid: false,
    titleInputValid: false,
    guestData: GuestData(),
  );

  final FormzSubmissionStatus? formzSubmissionStatus;
  final NDAFormStep? formStepCurrent;
  late FullNameInput? fullNameInput;
  late TitleInput? titleInput;
  late bool? fullNameInputValid;
  late bool? titleInputValid;
  late GuestData? guestData;
  late ClientData? clientData;
  late EventData? eventData;
  late List<ExperienceData>? experiencesData;

  NDAFormState copyWith({
    FormzSubmissionStatus? formzSubmissionStatus,
    NDAFormStep? formStepCurrent,
    FullNameInput? fullNameInput,
    TitleInput? titleInput,
    bool? fullNameInputValid,
    bool? titleInputValid,
    GuestData? guestData,
    ClientData? clientData,
    EventData? eventData,
    List<ExperienceData>? experiencesData,
  }) {
    return NDAFormState(
      formzSubmissionStatus: formzSubmissionStatus ?? this.formzSubmissionStatus,
      formStepCurrent: formStepCurrent ?? this.formStepCurrent,
      fullNameInput: fullNameInput ?? this.fullNameInput,
      titleInput: titleInput ?? this.titleInput,
      fullNameInputValid: fullNameInputValid ?? this.fullNameInputValid,
      titleInputValid: titleInputValid ?? this.titleInputValid,
      guestData: guestData ?? this.guestData,
      clientData: clientData ?? this.clientData,
      eventData: eventData ?? this.eventData,
      experiencesData: experiencesData ?? this.experiencesData,
    );
  }

  @override
  List<Object?> get props => [
    formzSubmissionStatus,
    formStepCurrent,
    fullNameInput,
    titleInput,
    fullNameInputValid,
    titleInputValid,
    guestData,
    clientData,
    eventData,
    experiencesData,
  ];
}


