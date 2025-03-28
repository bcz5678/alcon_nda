import 'package:alcon_flex_nda/data/data.dart';

class NdaTextSections {
  NdaTextSections({
    required this.clientData,
    required this.eventData,
    required this.guestData,
});

  final ClientData clientData;
  final EventData eventData;
  final GuestData guestData;

  ///Sections

  // Title
  late String title;

  // Paragraph 1
  late String p1_s1;
  late String p1_effectiveDate;
  late String p1_s2;
  late String p1_guestName;
  late String p1_s3;
  late String p1_guestAddress;
  late String p1_s4;

  // Paragraph 2,3
  late String p2_s1;
  late String p3_s1;

  // Paragraph 4
  late String p4_s1;
  late List<String> p4_experienceList;



  void init() {
    title = r'Confidentiality Agreement for Surgical Diagnostic Equipment Discussion';

    // Paragraph 1
    p1_s1 =  r'THIS CONFIDENTIALITY AGREEMENT (this "Agreement") is effective as of ';
    p1_effectiveDate = '  ${clientData.clientDate.toString()}  ';
    p1_s2 =  r' (the "Effective Date"), by and between Alcon Research, LLC ("Alcon") and ';
    p1_guestName = '  ${guestData.fullName}  ';
    p1_s3 = r'[Print Name Clearly] with an address of ';
    p1_guestAddress = '  ${guestData.address_1}${guestData.address_2 != ", " ? ", ${guestData.address_2.toString()}, " : null }${guestData.city},  ${guestData.state} ${guestData.zipcode}   ';
    p1_s4 = '("Receiving Party").';

    // Paragraph 2,3
    p2_s1 = r'WHEREAS Alcon possesses certain confidential or proprietary information and is willing to disclose such confidential or proprietary information to Receiving Party, subject to the terms and conditions set forth herein.';
    p3_s1 = r'NOW, THEREFORE, the Receiving Party agrees as follows:';

    // Paragraph 4
    p4_s1 = r'Alcon or an Affiliate of Alcon (as defined herein) may disclose to Receiving Party certain information, data and/or materials which Alcon regards as being confidential, constituting trade secrets or as being otherwise proprietary in nature (hereinafter "Confidential Information"), for the purpose of allowing Receiving Party to review the Confidential Information in order to give input to Alcon relating to proprietary:';
    p4_experienceList = createExperiencesNameList(guestData.experiencesSelected!);

  }

  List<String> createExperiencesNameList(List<ExperienceData> data) {
    List<String> returnList = [];

    for(var index = 0; index < data.length; index++) {
      returnList.add(data[index].name);
    }

    return returnList;
  }
}