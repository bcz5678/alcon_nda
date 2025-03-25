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
    this.address1Input,
    this.address2Input,
    this.cityInput,
    this.stateAbbrInput,
    this.zipcodeInput,
    this.fullNameInputValid,
    this.titleInputValid,
    this.address1InputValid,
    this.address2InputValid,
    this.cityInputValid,
    this.stateAbbrInputValid,
    this.zipcodeInputValid,
    this.guestData,
    this.clientData,
    this.eventData,
    this.experiencesData,
    this.selectedExperiences,
});

  NDAFormState.initial()
      : this(
    formzSubmissionStatus: FormzSubmissionStatus.initial,
    formStepCurrent: NDAFormStep.start,
    fullNameInput: FullNameInput.pure(),
    titleInput: TitleInput.pure(),
    address1Input: Address1Input.pure(),
    address2Input: Address2Input.pure(),
    cityInput: CityInput.pure(),
    stateAbbrInput: StateAbbrInput.pure(),
    zipcodeInput: ZipcodeInput.pure(),
    fullNameInputValid: false,
    titleInputValid: false,
    address1InputValid: false,
    address2InputValid: false,
    cityInputValid: false,
    stateAbbrInputValid: false,
    zipcodeInputValid: false,
    guestData: GuestData(),
    selectedExperiences: [],
  );

  final FormzSubmissionStatus? formzSubmissionStatus;
  final NDAFormStep? formStepCurrent;
  late FullNameInput? fullNameInput;
  late TitleInput? titleInput;
  late Address1Input? address1Input;
  late Address2Input? address2Input;
  late CityInput? cityInput;
  late StateAbbrInput? stateAbbrInput;
  late ZipcodeInput? zipcodeInput;
  late bool? fullNameInputValid;
  late bool? titleInputValid;
  late bool? address1InputValid;
  late bool? address2InputValid;
  late bool? cityInputValid;
  late bool? stateAbbrInputValid;
  late bool? zipcodeInputValid;
  late GuestData? guestData;
  late ClientData? clientData;
  late EventData? eventData;
  late List<ExperienceData>? experiencesData;
  late List<ExperienceData>? selectedExperiences;

  NDAFormState copyWith({
    FormzSubmissionStatus? formzSubmissionStatus,
    NDAFormStep? formStepCurrent,
    FullNameInput? fullNameInput,
    TitleInput? titleInput,
    Address1Input? address1Input,
    Address2Input? address2Input,
    CityInput? cityInput,
    StateAbbrInput? stateAbbrInput,
    ZipcodeInput? zipcodeInput,
    bool? fullNameInputValid,
    bool? titleInputValid,
    bool? address1InputValid,
    bool? address2InputValid,
    bool? cityInputValid,
    bool? stateAbbrInputValid,
    bool? zipcodeInputValid,
    GuestData? guestData,
    ClientData? clientData,
    EventData? eventData,
    List<ExperienceData>? experiencesData,
    List<ExperienceData>? selectedExperiences,
  }) {
    return NDAFormState(
      formzSubmissionStatus: formzSubmissionStatus ?? this.formzSubmissionStatus,
      formStepCurrent: formStepCurrent ?? this.formStepCurrent,
      fullNameInput: fullNameInput ?? this.fullNameInput,
      titleInput: titleInput ?? this.titleInput,
      address1Input: address1Input ?? this.address1Input,
      address2Input: address2Input ?? this.address2Input,
      cityInput: cityInput ?? this.cityInput,
      stateAbbrInput: stateAbbrInput ?? this.stateAbbrInput,
      zipcodeInput: zipcodeInput ?? this.zipcodeInput,
      fullNameInputValid: fullNameInputValid ?? this.fullNameInputValid,
      titleInputValid: titleInputValid ?? this.titleInputValid,
      address1InputValid: address1InputValid ?? this.address1InputValid,
      address2InputValid: address2InputValid ?? this.address2InputValid,
      cityInputValid: cityInputValid ?? this.cityInputValid,
      stateAbbrInputValid: stateAbbrInputValid ?? this.stateAbbrInputValid,
      zipcodeInputValid: zipcodeInputValid ?? this.zipcodeInputValid,
      guestData: guestData ?? this.guestData,
      clientData: clientData ?? this.clientData,
      eventData: eventData ?? this.eventData,
      experiencesData: experiencesData ?? this.experiencesData,
      selectedExperiences: selectedExperiences ?? this.selectedExperiences,
    );
  }

  @override
  List<Object?> get props => [
    formzSubmissionStatus,
    formStepCurrent,
    fullNameInput,
    titleInput,
    address1Input,
    address2Input,
    cityInput,
    stateAbbrInput,
    zipcodeInput,
    fullNameInputValid,
    titleInputValid,
    address1InputValid,
    address2InputValid,
    cityInputValid,
    stateAbbrInputValid,
    zipcodeInputValid,
    guestData,
    clientData,
    eventData,
    experiencesData,
    selectedExperiences,
  ];
}


