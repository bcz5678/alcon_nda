import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aws_s3_upload_lite/aws_s3_upload_lite.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:alcon_flex_nda/data/data.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../authentication/GoogleAuthCliient.dart';

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
    on<NDAFormExperienceSelectAll>(onNDAFormExperienceSelectAll);
    on<NDAFormExperienceUnselectAll>(onNDAFormExperienceUnselectAll);
    on<NDAFormAddSignature>(onNDAFormAddSignature);
    on<NDASaveAndSubmitPdf>(onNDASaveAndSubmitPdf);
    on<NDAResetApp>(onNDAResetApp);
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

  void onNDAFormExperienceSelectAll(
      NDAFormExperienceSelectAll event,
      Emitter<NDAFormState> emit
      ) {

    var experiencesList = jsonDecode(experiencesJsonData);
    List<ExperienceData>? _selectedExperiences = [];

    for (var item in experiencesList["data"]) {
      _selectedExperiences.add(
          ExperienceData(
            name: item["name"] as String,
            dates:item["dates"] as String,
            description: item["description"] as String,
          )
      );
    }

    emit(
        state.copyWith(
          selectedExperiences: _selectedExperiences,
        )
    );
  }

  void onNDAFormExperienceUnselectAll(
      NDAFormExperienceUnselectAll event,
      Emitter<NDAFormState> emit
      ) {

    List<ExperienceData>? _selectedExperiences = [];

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
          isSigned: true,
        )
    );
  }


  void onNDASaveAndSubmitPdf(
      NDASaveAndSubmitPdf event,
      Emitter<NDAFormState> emit
      ) async{

    emit(
      state.copyWith(
        pdfSubmissionStatus: PdfSubmissionStatus.building,
      )
    );

    print('nda_form_bloc -> onNDASavePdf');

    try {
      var _savedPdf = await event.pdfViewerController
          .saveDocument(flattenOption: PdfFlattenOption.formFields);

      emit(
          state.copyWith(
            savedPdf: _savedPdf,
          )
      );


      print('nda_form_bloc -> onNDASavePdf -> postSave');
      File _memoryPdfFile = await createMemoryPdfFile(_savedPdf);

      print(_memoryPdfFile);

      print('nda_form_bloc -> onNDASavePdf -> postSaveAnd Emit');


      NDASubmitPdf(
        _memoryPdfFile,
        emit
      );

    } catch(e) {

      emit(
          state.copyWith(
            pdfSubmissionStatus: PdfSubmissionStatus.submissionError,
          )
      );
    }
  }

  Future<void> NDASubmitPdf(
      File memoryPdfFile,
      Emitter<NDAFormState> emit
      ) async {

    print('nda_form_bloc -> onNDASubmitPdf -> Entry');

    emit(
        state.copyWith(
          pdfSubmissionStatus: PdfSubmissionStatus.submitting,
        )
    );

    print('nda_form_bloc -> onNDASubmitPdf -> ${state.pdfSubmissionStatus}');


    try{

      await uploadAWSByFile(
          memoryPdfFile
      );



      emit(
          state.copyWith(
            pdfSubmissionStatus: PdfSubmissionStatus.submitted,
          )
      );

      print('nda_form_bloc -> onNDASubmitPdf -> ${state.pdfSubmissionStatus}');

    } catch(e) {
      emit(
          state.copyWith(
            pdfSubmissionStatus: PdfSubmissionStatus.submissionError,
          )
      );
    }
  }


  void onNDAResetApp(
      NDAResetApp event,
      Emitter<NDAFormState> emit
      ) {
    try{
      emit(
          state.copyWith(
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
          )
      );
    } catch(e) {

    }
  }



  EventData getEventDataFromLocal() {
    var response = jsonDecode(eventJsonData);

    return EventData(
      eventDisplayName: response["eventDisplayName"] as String,
      eventDate: response["eventDate"] != "" ? DateTime.parse(response["eventDate"]) : DateTime.now(),
      eventState: response["eventState"] as String,
      eventCity: response["eventCity"] as String,
      eventCongressConvention: response["eventCongressConvention"] as String,
      eventWelcomeParagraph: response["eventWelcomeParagraph"] as String,
    );
  }

  List<ExperienceData> getGetAllExperiencesDataFromLocal() {
    List<ExperienceData> returnList = [];
    var response = jsonDecode(experiencesJsonData);

    for (var item in response["data"]) {
      returnList.add(
          ExperienceData(
            name: item["name"] as String,
            dates: item["dates"] as String,
            description: item["description"] as String,
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


  Future<void> uploadAWSByFile(File memoryPdfFile) async {
    String response = await AwsS3.uploadUint8List(
        accessKey: awsAccessKey,
        secretKey: awsSecretKey,
        file: memoryPdfFile.readAsBytesSync(),
        bucket: "alcon-signed",
        region: "us-east-1",
        destDir: 'nda',
        filename: "${state.guestData!.fullName!} - ${state.eventData!.eventDisplayName}.pdf",
      useSSL: false,
    );

    print(response);
  }

  Future<File> createMemoryPdfFile(List<int> _pdfFile) async {
    final FileSystem fs = MemoryFileSystem();
    final Directory tmp = await fs.systemTempDirectory.createTemp('example_');
    final File outputFile = tmp.childFile('tmpPdfFile');
    await outputFile.writeAsBytes(_pdfFile);
    return outputFile;
  }

