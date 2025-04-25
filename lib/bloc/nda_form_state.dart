part of 'nda_form_bloc.dart';

enum NDAFormStep {
  start,
  addExperiences,
  signature,
  submit
}

enum PdfSubmissionStatus {
  waiting,
  building,
  submitting,
  submitted,
  submissionError,
}

class NDAFormState extends Equatable{
  NDAFormState({
    required this.formzSubmissionStatus,
    required this.formStepCurrent,
    this.pdfSubmissionStatus,
    this.fullNameInput,
    this.titleInput,
    this.address1Input,
    this.address2Input,
    this.cityInput,
    this.stateAbbrInput,
    this.zipcodeInput,
    this.guestData,
    this.clientData,
    this.eventData,
    this.experiencesData,
    this.selectedExperiences,
    this.isSigned = false,
    this.savedPdf,
});

  NDAFormState.initial()
      : this(
    formzSubmissionStatus: FormzSubmissionStatus.initial,
    formStepCurrent: NDAFormStep.start,
    pdfSubmissionStatus: PdfSubmissionStatus.waiting,
    fullNameInput: FullNameInput.pure(),
    titleInput: TitleInput.pure(),
    address1Input: Address1Input.pure(),
    address2Input: Address2Input.pure(),
    cityInput: CityInput.pure(),
    stateAbbrInput: StateAbbrInput.pure(),
    zipcodeInput: ZipcodeInput.pure(),
    guestData: GuestData(),
    selectedExperiences: [],
    isSigned: false,
  );

  final FormzSubmissionStatus? formzSubmissionStatus;
  final NDAFormStep? formStepCurrent;
  final PdfSubmissionStatus? pdfSubmissionStatus;
  late FullNameInput? fullNameInput;
  late TitleInput? titleInput;
  late Address1Input? address1Input;
  late Address2Input? address2Input;
  late CityInput? cityInput;
  late StateAbbrInput? stateAbbrInput;
  late ZipcodeInput? zipcodeInput;
  late GuestData? guestData;
  late ClientData? clientData;
  late EventData? eventData;
  late List<ExperienceData>? experiencesData;
  late List<ExperienceData>? selectedExperiences;
  late bool isSigned;
  late List<int>? savedPdf;

  NDAFormState copyWith({
    FormzSubmissionStatus? formzSubmissionStatus,
    NDAFormStep? formStepCurrent,
    PdfSubmissionStatus? pdfSubmissionStatus,
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
    bool? isSigned,
    List<int>? savedPdf,
  }) {
    return NDAFormState(
      formzSubmissionStatus: formzSubmissionStatus ?? this.formzSubmissionStatus,
      formStepCurrent: formStepCurrent ?? this.formStepCurrent,
      pdfSubmissionStatus: pdfSubmissionStatus ?? this.pdfSubmissionStatus,
      fullNameInput: fullNameInput ?? this.fullNameInput,
      titleInput: titleInput ?? this.titleInput,
      address1Input: address1Input ?? this.address1Input,
      address2Input: address2Input ?? this.address2Input,
      cityInput: cityInput ?? this.cityInput,
      stateAbbrInput: stateAbbrInput ?? this.stateAbbrInput,
      zipcodeInput: zipcodeInput ?? this.zipcodeInput,
      guestData: guestData ?? this.guestData,
      clientData: clientData ?? this.clientData,
      eventData: eventData ?? this.eventData,
      experiencesData: experiencesData ?? this.experiencesData,
      selectedExperiences: selectedExperiences ?? this.selectedExperiences,
      isSigned: isSigned ?? this.isSigned,
      savedPdf: savedPdf ?? this.savedPdf,
    );
  }

  @override
  List<Object?> get props => [
    formzSubmissionStatus,
    formStepCurrent,
    pdfSubmissionStatus,
    fullNameInput,
    titleInput,
    address1Input,
    address2Input,
    cityInput,
    stateAbbrInput,
    zipcodeInput,
    guestData,
    clientData,
    eventData,
    experiencesData,
    selectedExperiences,
    isSigned,
    savedPdf,
  ];
}


