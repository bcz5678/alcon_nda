import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_ui/app_ui.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, AssetImage> imageAssets = {};
  late bool _fullNameDisplayMessage;
  late bool _titleDisplayMessage;
  late bool _address1DisplayMessage;
  late bool _address2DisplayMessage;
  late bool _cityDisplayMessage;
  late bool _stateAbbrDisplayMessage;
  late bool _zipcodeDisplayMessage;
  late Image logoImage;

  @override
  void initState() {
    context.read<NDAFormBloc>().add(NDAGetEventData());
    context.read<NDAFormBloc>().add(NDAGetAllExperiencesData());
    context.read<NDAFormBloc>().add(NDAGetClientData());
    _fullNameDisplayMessage = false;
    _titleDisplayMessage = false;
    _address1DisplayMessage = false;
    _address2DisplayMessage = false;
    _cityDisplayMessage = false;
    _stateAbbrDisplayMessage = false;
    _zipcodeDisplayMessage = false;
    logoImage = Image.asset('images/alcon-logo-2019.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logoImage.image, context);
  }

  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;

    var validList = [
      state.fullNameInput!.isValid,
      state.titleInput!.isValid,
      state.address1Input!.isValid,
      state.address2Input!.isValid,
      state.cityInput!.isValid,
      state.stateAbbrInput!.isValid,
      state.zipcodeInput!.isValid
    ];

    if (validList.every((val) => val == true)) {
      context.read<NDAFormBloc>().add(NDAFormDetailsSubmitted());
      context.go('/step_two');

    } else {
      setState(() {
        _fullNameDisplayMessage = !state.fullNameInput!.isValid;
        _titleDisplayMessage = !state.titleInput!.isValid;
        _address1DisplayMessage = !state.address1Input!.isValid;
        _address2DisplayMessage = !state.address2Input!.isValid;
        _cityDisplayMessage = !state.cityInput!.isValid;
        _stateAbbrDisplayMessage = !state.stateAbbrInput!.isValid;
        _zipcodeDisplayMessage = !state.zipcodeInput!.isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        child: StickyFooter(
          currentStep: 1,
          onPressedFunction: onPressedFooterFunction,
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomScrollView(
            primary: false,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width >= 1000
                        ? 1000
                        : constraints.maxWidth,
                      child: Padding(
                        padding: MediaQuery.of(context).size.width >= 1000
                            ? const EdgeInsets.all(0.0)
                            : const EdgeInsets.symmetric(horizontal: 10.0),
                        child:  BlocBuilder<NDAFormBloc, NDAFormState>(
                          builder: (context, state) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.20,
                                    child: Image(
                                        image: AssetImage(
                                            'images/alcon-logo-2019.png')
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 0),
                                  child: Text(
                                    "Welcome to ${state.eventData!
                                        .eventDisplayName}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                          color: Colors.black.withAlpha(175),
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 0),
                                  child: Text(
                                    state.eventData!.eventWelcomeParagraph!,
                                    style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                          color: Colors.black.withAlpha(175),
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.normal,
                                        )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 0),
                                  child: Text(
                                    "Please Fill In The Following Details",
                                    style: GoogleFonts.notoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black.withAlpha(175),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 20, 0, 0),
                                  child: BlocBuilder<NDAFormBloc, NDAFormState>(
                                      builder: (context, state) {
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: 700),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 10,),
                                                child: _FullNameInput(
                                                  displayMessageState: _fullNameDisplayMessage,
                                                ),
                                              ),
                                              _TitleInput(
                                                displayMessageState: _titleDisplayMessage,
                                              ),
                                              _Address1Input(
                                                displayMessageState: _address1DisplayMessage,
                                              ),
                                              _Address2Input(
                                                displayMessageState: _address2DisplayMessage,
                                              ),
                                              _CityInput(
                                                displayMessageState: _cityDisplayMessage,
                                              ),
                                              _StateAbbrInput(
                                                displayMessageState: _stateAbbrDisplayMessage,
                                              ),
                                              _ZipcodeInput(
                                                displayMessageState: _zipcodeDisplayMessage,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _FullNameInput extends StatefulWidget {
  _FullNameInput({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_FullNameInput> createState() => _FullNameInputState();
}

class _FullNameInputState extends State<_FullNameInput> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Full Name ",
                    style: UITextStyle.labelLarge,
                  ),
                  TextSpan(
                    text: "*",
                    style: UITextStyle.labelLarge.copyWith(
                      color: AppColors.red,
                    )
                  )
                ],
              )
            ),
          ),
          AppFullNameTextField(
            key: const Key('formInput_step1_fullNameInput'),
            initialValue: state.guestData!.fullName ?? null,
            readOnly: state.formzSubmissionStatus?.isInProgress,
            hintText: "Please enter your full name",
            errorText: widget.displayMessageState ? "Please enter a valid full name" : null,
            onChanged: (value) {
              context.read<NDAFormBloc>().add(NDAFormFullNameChanged(value));
            },
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _TitleInput extends StatefulWidget {
  _TitleInput({
    required this.displayMessageState,
  });

final bool displayMessageState;

  @override
  State<_TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<_TitleInput> {

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;


    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Job Title",
                style: UITextStyle.labelLarge,
              ),
            ),
            AppTitleTextField(
              key: const Key('formInput_step1_titleInput'),
              initialValue: state.guestData!.title ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your job title",
              errorText: widget.displayMessageState ? "Please enter a valid job title" : null,
              onChanged: (value)  {
                context.read<NDAFormBloc>().add(NDAFormTitleChanged(value));
              },
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _Address1Input extends StatefulWidget {
  _Address1Input({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_Address1Input> createState() => _Address1InputState();
}

class _Address1InputState extends State<_Address1Input> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Address ",
                        style: UITextStyle.labelLarge,
                      ),
                      TextSpan(
                          text: "*",
                          style: UITextStyle.labelLarge.copyWith(
                            color: AppColors.red,
                          )
                      )
                    ],
                  )
              ),
            ),
            AppAddressTextField(
              key: const Key('formInput_step1_address1Input'),
              initialValue: state.guestData!.address_1 ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your address",
              errorText: widget.displayMessageState ? "Please enter a valid address" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormAddress1Changed(value)),
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


class _Address2Input extends StatefulWidget {
  _Address2Input({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_Address2Input> createState() => _Address2InputState();
}

class _Address2InputState extends State<_Address2Input> {

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Floor/Suite/Apt",
                style: UITextStyle.labelLarge,
              ),
            ),
            AppAddressTextField(
              key: const Key('formInput_step1_address2Input'),
              initialValue: state.guestData!.address_2 ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your floor/suite/apt",
              errorText: widget.displayMessageState ? "Please enter a valid floor/suite/apt" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormAddress2Changed(value)),
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


class _CityInput extends StatefulWidget {
  _CityInput({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<_CityInput> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "City ",
                        style: UITextStyle.labelLarge,
                      ),
                      TextSpan(
                          text: "*",
                          style: UITextStyle.labelLarge.copyWith(
                            color: AppColors.red,
                          )
                      )
                    ],
                  )
              ),
            ),
            AppCityTextField(
              key: const Key('formInput_step1_cityInput'),
              initialValue: state.guestData!.city ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your city",
              errorText: widget.displayMessageState ? "Please enter a valid city" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormCityChanged(value)),
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


class _StateAbbrInput extends StatefulWidget {
  _StateAbbrInput({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_StateAbbrInput> createState() => _StateAbbrInputState();
}

class _StateAbbrInputState extends State<_StateAbbrInput> {

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "State ",
                        style: UITextStyle.labelLarge,
                      ),
                      TextSpan(
                          text: "*",
                          style: UITextStyle.labelLarge.copyWith(
                            color: AppColors.red,
                          )
                      )
                    ],
                  )
              ),
            ),
            AppStateAbbrDropdownField(
              key: const Key('formInput_step1_stateAbbrInput'),
              initialValue: state.guestData!.state ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your state",
              errorText: widget.displayMessageState ? "Please enter a valid state" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormStateAbbrChanged(value)),
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _ZipcodeInput extends StatefulWidget {
  _ZipcodeInput({
    required this.displayMessageState,
  });

  final bool displayMessageState;

  @override
  State<_ZipcodeInput> createState() => _ZipcodeInputState();
}

class _ZipcodeInputState extends State<_ZipcodeInput> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<NDAFormBloc>().state;

    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Zipcode ",
                        style: UITextStyle.labelLarge,
                      ),
                      TextSpan(
                          text: "*",
                          style: UITextStyle.labelLarge.copyWith(
                            color: AppColors.red,
                          )
                      )
                    ],
                  )
              ),
            ),
            AppZipcodeTextField(
              key: const Key('formInput_step1_zipcodeInput'),
              initialValue: state.guestData!.zipcode ?? null,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your zipcode",
              errorText: widget.displayMessageState ? "Please enter a valid zipcode" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormZipcodeChanged(value)),
            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}







