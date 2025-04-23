import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:alcon_flex_nda/data/data.dart';
import 'package:bloc/bloc.dart';
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
    on<NDASavePdf>(onNDASavePdf);
    on<NDASubmitPdf>(onNDASubmitPdf);
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


  void onNDASavePdf(
      NDASavePdf event,
      Emitter<NDAFormState> emit
      ) async{

    emit(
      state.copyWith(
        pdfSubmissionStatus: PdfSubmissionStatus.building,
      )
    );

    try {
      var _savedPdf = await event.pdfViewerController
          .saveDocument(flattenOption: PdfFlattenOption.formFields);

      emit(
          state.copyWith(
            savedPdf: _savedPdf,
          )
      );

      NDASubmitPdf();

    } catch(e) {
      emit(
          state.copyWith(
            pdfSubmissionStatus: PdfSubmissionStatus.error,
          )
      );
    }

  }

  void onNDASubmitPdf(
      NDASubmitPdf event,
      Emitter<NDAFormState> emit
      ) {

    print('nda_form_bloc -> onNDASubmitForm -> Entry');

    emit(
        state.copyWith(
          pdfSubmissionStatus: PdfSubmissionStatus.submitting,
        )
    );

    print('nda_form_bloc -> onNDASubmitPdf -> ${state.pdfSubmissionStatus}');

    try{


      emit(
          state.copyWith(
            pdfSubmissionStatus: PdfSubmissionStatus.submitted,
          )
      );

      print('nda_form_bloc -> onNDASubmitPdf -> ${state.pdfSubmissionStatus}');

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


  /*
  Future<void> loginToDrive() async {
    final googleSignIn = signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    final signIn.GoogleSignInAccount? account = await googleSignIn.signIn();
    Map<String, String>? _authHeaders = await account?.authHeaders;
  }

  Future<void> uploadToDrive({
    required List<int?> pdfFile,
  }) async {

    //final Directory directory = await getApplicationDocumentsDirectory();
    final File file1 = File('${directory.path}/my_file.txt');
    //file1.writeAsStringSync(jsonEncode(humanList));

    var client = GoogleAuthClient(authHeaders);
    var ga = drive.DriveApi(client);
    var response;

    drive.File fileToUpload = drive.File();
    //pre defined string variable for the file name
    fileToUpload.name = fileName;
    try {
      response = await ga.files.create(
        fileToUpload,
        uploadMedia: drive.Media(file1.openRead(), file1.lengthSync()),
      );
    } catch (e) {
      print(e);
    }

   */
}




