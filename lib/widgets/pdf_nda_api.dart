import 'dart:ui';

import 'package:alcon_flex_nda/data/data.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfNdaApi {
  PdfNdaApi({
    required this.guestData,
    required this.eventData,
    required this.clientData,
  });

  final GuestData guestData;
  final EventData eventData;
  final ClientData clientData;

  late PdfDocument _document;

  late PdfPage page1;
  late PdfPage page2;
  late PdfPage page3;

  late double pageWidth;
  late double pageHeight;
  late PdfFont defaultFont;
  late PdfFont underlineFont;
  late PdfFont boldUnderlineFont;
  late PdfFont italicFont;

  // holds each variable underlined form entry to calculate teh
  // layoutResult bounds for the underlineFont entry
  late Size measuredTextSize;

  // Holds each variable text so it is only built once and reused
  late String tempText;

  // Default spacing for legal paragraph start
  late double defaultParagraphIndentation;

  //Variable to combine multiple measuredTexts for small lines
  late double combinedMeasureText;



  Future<List<int>> generateNDA() async {
    PdfTextElement textElement;
    PdfOrderedList listElement;
    PdfLayoutResult? layoutResult;
    List<int> _savedDocument;
    PdfShapeElement signatureElement;
    PdfButtonField signatureButton;

    //Initialize Main Document Layout
    _document = PdfDocument();

    page1 = _document.pages.add();
    page2 = _document.pages.add();
    page3 = _document.pages.add();

    // Set size and orientation settings
    _document.pageSettings.size = PdfPageSize.letter;
    _document.pageSettings.orientation = PdfPageOrientation.portrait;

    double pageWidth = _document.pageSettings.width - (_document.pageSettings.margins.left * 2) - 20;
    double pageHeight =  _document.pageSettings.height;

    defaultParagraphIndentation = 50;

    //Set the fonts
    defaultFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      12
    );

    underlineFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      style: PdfFontStyle.underline
    );

    boldUnderlineFont = PdfStandardFont(
      PdfFontFamily.helvetica,
      12,
      multiStyle:[
        PdfFontStyle.underline,
        PdfFontStyle.bold,
    ]);

    italicFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
        style: PdfFontStyle.italic,
    );

    // Set Layout format to span page breaks and set pagination bounds
    PdfLayoutFormat layoutFormat = PdfLayoutFormat(
      layoutType: PdfLayoutType.paginate,
      breakType: PdfLayoutBreakType.fitPage,
    );

    //Create the footer with specific bounds
    PdfPageTemplateElement footer = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, _document.pageSettings.size.width, 50));

//Create the page number field
    PdfPageNumberField pageNumber = PdfPageNumberField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

//Sets the number style for page number
    pageNumber.numberStyle = PdfNumberStyle.upperRoman;

//Create the page count field
    PdfPageCountField count = PdfPageCountField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 14),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

//set the number style for page count
    count.numberStyle = PdfNumberStyle.upperRoman;


    //Generate Title
    textElement = PdfTextElement(
      text: 'Confidentiality Agreement for Surgical Diagnostic Equipment Discussion',
      font: boldUnderlineFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
      ),
    );

    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, 0, pageWidth, 0),
      format: layoutFormat,
    )!;

    //Add Paragraph pre-EFFECTIVE DATE
    textElement.font = defaultFont;
    textElement.text =
      r'THIS CONFIDENTIALITY AGREEMENT (this "Agreement") is effective as of ';
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
      paragraphIndent: defaultParagraphIndentation,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, 0, 0),
      format: layoutFormat,
    )!;


    //Add EFFECTIVE DATE, underlined
    textElement.font = underlineFont;
    tempText = '${DateFormat.MMMMd().format(clientData.clientDate)}, ${DateFormat.y().format(clientData.clientDate)}'.toUpperCase();
    textElement.text = tempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult.bounds.bottom + 1, 0, 0),
      format: layoutFormat,
    )!;

    // Store the Effective Date text Size
    measuredTextSize = underlineFont.measureString(tempText);
    combinedMeasureText = measuredTextSize.width;

    //Add paragraph post-EFFECTIVE DATE
    textElement.font = defaultFont;
    tempText = r' (the "Effective Date"), by and between Alcon Research, LLC ("Alcon") and ';
    textElement.text = tempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: (measuredTextSize.width),
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
      0, layoutResult!.bounds.top, pageWidth, 0),
      format: layoutFormat,
    )!;



    // Combine and set overflow
    combinedMeasureText += underlineFont.measureString(tempText).width;

    print('combinedMeasureText - ${combinedMeasureText}');
    print('pageWidth - ${pageWidth}');

    var overflowMeasureText = (combinedMeasureText - pageWidth) > 0
                              ? (combinedMeasureText - pageWidth)
                              : 0.0;

    print('overflowMeasureText - ${overflowMeasureText}');

    //Add GUEST FULLNAME, underlined
    combinedMeasureText = overflowMeasureText;



    textElement.font = underlineFont;
    tempText = 'BRIAN COLLIER'.toUpperCase();

    textElement.text = tempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: overflowMeasureText + 15,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult.bounds.bottom - measuredTextSize.height, 0, 0),
      format: layoutFormat,
    )!;


    // Set fullName MeasuredTextSize
    measuredTextSize = underlineFont.measureString(tempText);
    combinedMeasureText = measuredTextSize.width + 30;

    //Add paragraph post-GUEST FULL NAME
    textElement.font = defaultFont;
    tempText = r'with an address of ';
    textElement.text = tempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: combinedMeasureText ,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.top, 0, 0),
      format: layoutFormat,
    )!;
    measuredTextSize = defaultFont.measureString(tempText);

    // Add  to the combined text
    combinedMeasureText += measuredTextSize.width;

    //Add GUEST ADDRESS, underlined
    textElement.font = underlineFont;
    tempText = '${guestData.address_1}${guestData.address_2 != "" ? ", ${guestData.address_2.toString()}, " : ", " }${guestData.city}, ${guestData.state} ${guestData.zipcode}'.toUpperCase();
    textElement.text = tempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: combinedMeasureText + 10,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult.bounds.top, pageWidth, 0),
      format: layoutFormat,
    )!;

    measuredTextSize = underlineFont.measureString(tempText);

    overflowMeasureText = (combinedMeasureText - pageWidth) > 0
        ? (combinedMeasureText - pageWidth)
        : 0.0;


    //Add paragraph post-GUEST ADDRESS
    textElement.font = defaultFont;
    textElement.text =
    r' ("Receiving Party").';
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: overflowMeasureText + 40,
    );

    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
         0, layoutResult!.bounds.bottom - measuredTextSize.height, 0, 0),
      format: layoutFormat,
    )!;

    // Reset Sizes
    measuredTextSize = Size(0,0);
    combinedMeasureText = 0;
    overflowMeasureText = 0;

    //Add Paragraph
    textElement.text =
      'WHEREAS Alcon possesses certain confidential or proprietary information and is willing to disclose such confidential or proprietary information to Receiving Party, subject to the terms and conditions set forth herein.';
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: defaultParagraphIndentation,
    );

    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, 0),
      format: layoutFormat,
    )!;

    //Add Paragraph
    textElement.text = 'NOW, THEREFORE, the Receiving Party agrees as follows:';
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, 0),
      format: layoutFormat,
    )!;

    //Add Paragraph
    textElement.text =
      'Alcon or an Affiliate of Alcon (as defined herein) may disclose to Receiving Party certain information, data and/or materials which Alcon regards as being confidential, constituting trade secrets or as being otherwise proprietary in nature (hereinafter "Confidential Information"), for the purpose of allowing Receiving Party to review the Confidential Information in order to give input to Alcon relating to proprietary:';
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


   listElement = PdfOrderedList(
      items: PdfListItemCollection(
          createExperiencesNameList(guestData.experiencesSelected!),
      ),
      font:defaultFont,
      indent: 20,
      format: PdfStringFormat(
          lineSpacing: 5
      ),
   );

    layoutResult = listElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
      'during the ${eventData.eventCongressConvention.toString().toUpperCase()} in ${eventData.eventCity.toString().toUpperCase()}, ${eventData.eventState.toString().toUpperCase()} (the "Purpose").';
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: 0,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
        "In consideration of Alcon\'s disclosure of the Confidential Information, Receiving Party agrees that it shall:";
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.left,
      paragraphIndent: defaultParagraphIndentation,
    );
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    // Add List
    listElement = PdfOrderedList(
      items: PdfListItemCollection([
        'use the Confidential Information disclosed by Alcon or an Affiliate of Alcon exclusively in connection with the Purpose permitted by this Agreement; and,',
        'use reasonable precautions to prevent disclosure of such Confidential Information to third parties, in no event less protective than those precautions that it takes with respect to its own confidential or proprietary information of a similar nature.'
      ]),
      font:defaultFont,
      marker: PdfOrderedMarker(
          style: PdfNumberStyle.lowerLatin
      ),
      style: PdfNumberStyle.lowerLatin,
      indent: 50,
      format: PdfStringFormat(
          lineSpacing: 2,
      ),
    );

    layoutResult = listElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;



    //Add Paragraph
    textElement.text =
      "The parties acknowledge that the foregoing is the sole consideration relating to Alcon\'s disclosure, and that no payment is contemplated relating to Receiving Party\’s review and evaluation of Alcon\’s proprietary surgical equipment.";
    textElement.font = underlineFont;
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'As utilized herein, the term “Affiliate of Alcon” means any entity or person that controls, is controlled by, or is under common control with Alcon. For the purpose of this definition, “control” or “controlled” means direct or indirect ownership of fifty percent (50%) or more of the shares of stock entitled to vote for the election of directors in the case of a corporation or fifty percent (50%) or more of the equity interest in the case of any other type of legal entity; status as a general partner in any partnership; or any other arrangement whereby the entity or person controls or has the right to control the board of directors or equivalent governing body of a corporation or other entity or the ability to cause the direction of the management or policies of a corporation or other entity.';
    textElement.font = defaultFont;
    layoutResult = textElement.draw(
      page: page1,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
      'The obligations of confidence and non-use assumed by Receiving Party hereunder shall not apply to any Confidential Information which Receiving Party can demonstrate:';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    // Add List
    listElement = PdfOrderedList(
      items: PdfListItemCollection([
        'was at the time of disclosure, or thereafter lawfully became, available to the public through no breach of this Agreement by the Receiving Party; or',
        'was known to, or was otherwise in the possession of, Receiving Party prior to the receipt of such Confidential Information; or',
        'was lawfully disclosed to Receiving Party by a third party not under an obligation of confidence to Alcon with respect to the Confidential Information.',
       ]),
      font:defaultFont,
      marker: PdfOrderedMarker(style: PdfNumberStyle.lowerLatin),
      style: PdfNumberStyle.lowerLatin,
      indent: 50,
      format: PdfStringFormat(
        lineSpacing: 2,
      ),
    );

    layoutResult = listElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
      'Receiving Party may disclose Confidential Information if compelled to do so by a court or administrative agency of competent jurisdiction, provided however, that in such case Receiving Party shall provide prompt written notice to Disclosing Party so that it may seek a protective order or other remedy from said court or administrative agency and Receiving Party shall only disclose that portion of such Confidential Information that, in the opinion of its legal counsel, is required to be disclosed.';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'Receiving Party agrees that it will not, without the prior written consent of Alcon, make any public announcement, public statement or any other disclosure to any person (except as may be expressly permitted hereunder or required herein) regarding the existence of this Agreement, or any of the terms, conditions or other facts relating to the Agreement (including the status thereof).';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'In the event Alcon gives Receiving Party prior written consent to disclose Confidential Information to any third party, Receiving Party hereby agrees to obtain written agreements from any such third party to whom Receiving Party discloses such information, similar in form and substance to this Confidentiality Agreement, for the benefit of Alcon.';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'At any time upon the request of Alcon, Receiving Party will return to Alcon all Confidential Information (and all copies thereof and extracts therefrom) or destroy all Confidential Information (and all copies thereof and extracts therefrom). Any destruction of Confidential Information shall be certified in writing by an authorized officer of Receiving Party.';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'This Agreement does not, and shall not be construed to, constitute the grant to Receiving Party of (i) any right or license to use any Confidential Information for any purpose other than those specified in this Agreement, (ii) any patent right or license, or (iii) the right to file any patent application containing or based upon any Confidential Information.';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'Receiving Party hereby acknowledges that Alcon\'s remedies at law for money damages may be inadequate in the event of a breach or threatened breach of this Confidentiality Agreement. Alcon shall be entitled to seek a temporary restraining order, injunctive relief or other equitable relief in the event of any such breach or threatened breach without the requirement of posting bond, but nothing contained herein shall be construed as an election of remedies at law for damages incurred for such breach. In the event that Alcon brings suit to enforce this Confidentiality Agreement, Alcon shall be entitled to recover reasonable attorneys\' fees and court costs.';
    layoutResult = textElement.draw(
      page: page2,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'The term of this Agreement shall be for one (1) year from the date stated above. However, the foregoing obligations of confidentiality and non-use shall survive the expiration or termination of this Agreement.';
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0, layoutResult.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'This Agreement constitutes the entire understanding between the parties relating to the Purpose hereof. No amendment or modification to this Agreement will be valid or binding upon the parties unless made in writing and signed by each party.';
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    //Add Paragraph
    textElement.text =
    'This Agreement may be executed in two (2) or more counterparts, each of which shall constitute an original and all of which together shall constitute one and the same instrument.';
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;



    //Add Paragraph
    textElement.text =
    'IN WITNESS WHEREOF, the parties hereby execute this Confidentiality Agreement by their duly authorized Representative as of the Effective Date first above written.';
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0, layoutResult!.bounds.bottom + 20, pageWidth, pageHeight),
      format: layoutFormat,
    )!;


    var _preColumnLayoutResult = layoutResult;
    double _column1FieldStartOffset = 70.0;
    double _column2FieldStartOffset = 50.0;
    var _gutterWidth = 15;
    var _columnRowSpacing = 35;
    var _column1TempText = '';
    var _column2TempText = '';
    var underlineUnits = 25;
    var _columnMeasureText= Size(20,0);

    /// COLUMN 1

    // SIGNATURE - LABEL
    _column1TempText = 'Signature: ';
    textElement.font = defaultFont;
    textElement.text = _column1TempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
      paragraphIndent: 0,
    );
       layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0, _preColumnLayoutResult.bounds.bottom + 20 + _columnRowSpacing, pageWidth / 2, pageHeight),
      format: layoutFormat,
    )!;

    _columnMeasureText = defaultFont.measureString(_column1TempText);


    // SIGNATURE - DATA

    if(guestData.signature != null) {
      //print('signature not null -> ${guestData.signature}');
      signatureElement = PdfBitmap(guestData.signature!);

      layoutResult = signatureElement.draw(
        page: page3,
        bounds: Rect.fromLTWH(
            _column1FieldStartOffset, _preColumnLayoutResult.bounds.bottom + 20, pageWidth / 2 - _column1FieldStartOffset - _gutterWidth, _columnRowSpacing as double),
        format: layoutFormat,
      )!;

    }

    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 1) + _columnMeasureText.height,
        ),
        Offset(
          ((pageWidth / 2) - _gutterWidth),
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 1) + _columnMeasureText.height,
        )
    );


    // NAME - LABEL
    _column1TempText = "Name: ";
    textElement.font = defaultFont;
    textElement.text = _column1TempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
      paragraphIndent: 0,
    );
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    // NAME - Data
    _column1TempText = guestData.fullName.toString();
    textElement.font = defaultFont;
    textElement.text = _column1TempText;

    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2),
          pageWidth / 2 - _column1FieldStartOffset - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
      PdfPen(
        PdfColor(0, 0, 0),
        width: 0.5,
      ),
      Offset(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2) + _columnMeasureText.height,
      ),
      Offset(
          ((pageWidth / 2) - _gutterWidth),
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2) + _columnMeasureText.height,
      )
    );



    // TITLE - LABEL
    _column1TempText = "Title: ";
    textElement.font = defaultFont;
    textElement.text = _column1TempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
      paragraphIndent: 0,
    );
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    // TITLE - Data
    _column1TempText = guestData.title.toString() != null ? guestData.title.toString() : "";
    textElement.font = defaultFont;
    textElement.text = _column1TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3),
          pageWidth / 2 - _column1FieldStartOffset - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3) + _columnMeasureText.height,
        ),
        Offset(
          ((pageWidth / 2) - _gutterWidth),
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3) + _columnMeasureText.height,
        )
    );



    // DATE - LABEL
    _column1TempText = "Date: ";
    textElement.font = defaultFont;
    textElement.text = _column1TempText;
    textElement.stringFormat = PdfStringFormat(
      alignment: PdfTextAlignment.justify,
      paragraphIndent: 0,
    );
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          0,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    // Date - Data
    _column1TempText = DateFormat.yMd().format(DateTime.now()).toString();
    textElement.font = defaultFont;
    textElement.text = _column1TempText;


    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4),
          pageWidth / 2 - _column1FieldStartOffset - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          _column1FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4) + _columnMeasureText.height,
        ),
        Offset(
          ((pageWidth / 2) - _gutterWidth),
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4) + _columnMeasureText.height,
        )
    );


    /// COLUMN 2

    // ALCON TITLE
    _column2TempText = 'ALCON RESEARCH, LLC'.toUpperCase();
    textElement.font = defaultFont;
    textElement.text = _column2TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          pageWidth / 2, _preColumnLayoutResult.bounds.bottom + 20, pageWidth / 2, pageHeight),
      format: layoutFormat,
    )!;


    // BY - LABEL
    _column2TempText = "By: ";
    textElement.text = _column2TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          pageWidth / 2, _preColumnLayoutResult.bounds.bottom + 20 + _columnRowSpacing, pageWidth / 2, pageHeight),
      format: layoutFormat,
    )!;

    // By - Data
    _column2TempText = clientData.clientBySignature.toString();
    textElement.font = defaultFont;
    textElement.text = _column2TempText;

    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 1),
          pageWidth / 2 - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 1) + _columnMeasureText.height,
        ),
        Offset(
          pageWidth,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 1) + _columnMeasureText.height,
        )
    );


    // NAME - LABEL
    _column2TempText = "Name: ";
    textElement.text = _column2TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          pageWidth / 2,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    // Name - Data
    _column2TempText = clientData.clientName.toString();
    textElement.font = defaultFont;
    textElement.text = _column2TempText;

    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2),
          pageWidth / 2 - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2) + _columnMeasureText.height,
        ),
        Offset(
          pageWidth,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 2) + _columnMeasureText.height,
        )
    );


    // TITLE - LABEL
    _column2TempText = "Title: ";
    textElement.text = _column2TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          pageWidth / 2,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    // Title - Data
    _column2TempText = clientData.clientTitle.toString();
    textElement.font = defaultFont;
    textElement.text = _column2TempText;

    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3),
          pageWidth / 2 - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3) + _columnMeasureText.height,
        ),
        Offset(
          pageWidth,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 3) + _columnMeasureText.height,
        )
    );


    // DATE - LABEL
    _column2TempText = "Date: ";
    textElement.text = _column2TempText;
    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          pageWidth / 2,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4),
          pageWidth / 2,
          pageHeight
      ),
      format: layoutFormat,
    )!;

    // Title - Data
    _column2TempText = DateFormat.yMd().format(clientData.clientDate).toString();
    textElement.font = defaultFont;
    textElement.text = _column2TempText;

    layoutResult = textElement.draw(
      page: page3,
      bounds: Rect.fromLTWH(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4),
          pageWidth / 2 - _gutterWidth,
          pageHeight
      ),
      format: layoutFormat,
    )!;


    page3.graphics.drawLine(
        PdfPen(
          PdfColor(0, 0, 0),
          width: 0.5,
        ),
        Offset(
          (pageWidth / 2) + _column2FieldStartOffset,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4) + _columnMeasureText.height,
        ),
        Offset(
          pageWidth,
          _preColumnLayoutResult.bounds.bottom + 20 + (_columnRowSpacing * 4) + _columnMeasureText.height,
        )
    );



    _savedDocument = await savePdf(_document);

    return _savedDocument;
  }


  Future<List<int>> savePdf(PdfDocument document) async {
    List<int> documentBytes = await document.save();
    document.dispose();
    return documentBytes;
  }

  List<String> createExperiencesNameList(List<ExperienceData> data) {
    List<String> returnList = [];

    for(var index = 0; index < data.length; index++) {
      returnList.add(data[index].name);
    }

    return returnList;
  }

  String generateFieldWithUnderline({required int underlineUnits, required String dataString}) {
    late String returnString;

    if(dataString != "") {
      returnString = ("${dataString!}${"_" * underlineUnits}");

          "_" * (underlineUnits - dataString.length);
    } else {
      returnString = ("${dataString!}${"_" * underlineUnits}");
    }

    return returnString;
  }

}