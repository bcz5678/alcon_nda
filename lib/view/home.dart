import 'package:alcon_flex_nda/app.dart';
import 'package:alcon_flex_nda/data/data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';

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
    super.initState();
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StepTwo()),
      );
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
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width >= 1000
                        ? 1000
                        : constraints.maxWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                            child: const FractionallySizedBox(
                              widthFactor: 0.20,
                              child: Image(
                                  image: AssetImage('images/alcon-logo-2019.png')
                              ),
                            ),
                          ),
                          BlocBuilder<NDAFormBloc, NDAFormState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  "Welcome to ${state.eventData!.eventDisplayName}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black.withAlpha(175),
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ),
                                ),
                              );
                            },
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore.",
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
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: BlocBuilder<NDAFormBloc, NDAFormState>(
                              builder: (context, state) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 700),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,),
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
  const _FullNameInput({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_FullNameInput> createState() => _FullNameInputState();
}

class _FullNameInputState extends State<_FullNameInput> {
  final _controller = TextEditingController();

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
            controller: _controller,
            readOnly: state.formzSubmissionStatus?.isInProgress,
            hintText: "Please enter your full name",
            errorText: widget.displayMessageState ? "Please enter a valid full name" : null,
            onChanged: (value) =>
              context.read<NDAFormBloc>().add(NDAFormFullNameChanged(value)),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TitleInput extends StatefulWidget {
  const _TitleInput({
    required this.displayMessageState,
    super.key
  });

final bool displayMessageState;

  @override
  State<_TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<_TitleInput> {
  final _controller = TextEditingController();

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
              controller: _controller,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your job title",
              errorText: widget.displayMessageState ? "Please enter a valid job title" : null,
              onChanged: (value) =>
                  context.read<NDAFormBloc>().add(NDAFormTitleChanged(value)),            ),
          ],
        )
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _Address1Input extends StatefulWidget {
  const _Address1Input({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_Address1Input> createState() => _Address1InputState();
}

class _Address1InputState extends State<_Address1Input> {
  final _controller = TextEditingController();

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
              controller: _controller,
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
    _controller.dispose();
    super.dispose();
  }
}


class _Address2Input extends StatefulWidget {
  const _Address2Input({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_Address2Input> createState() => _Address2InputState();
}

class _Address2InputState extends State<_Address2Input> {
  final _controller = TextEditingController();

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
              controller: _controller,
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
    _controller.dispose();
    super.dispose();
  }
}


class _CityInput extends StatefulWidget {
  const _CityInput({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_CityInput> createState() => _CityInputState();
}

class _CityInputState extends State<_CityInput> {
  final _controller = TextEditingController();

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
              controller: _controller,
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
    _controller.dispose();
    super.dispose();
  }
}


class _StateAbbrInput extends StatefulWidget {
  const _StateAbbrInput({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_StateAbbrInput> createState() => _StateAbbrInputState();
}

class _StateAbbrInputState extends State<_StateAbbrInput> {
  final _controller = TextEditingController();

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
              controller: _controller,
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
    _controller.dispose();
    super.dispose();
  }
}

class _ZipcodeInput extends StatefulWidget {
  const _ZipcodeInput({
    required this.displayMessageState,
    super.key
  });

  final bool displayMessageState;

  @override
  State<_ZipcodeInput> createState() => _ZipcodeInputState();
}

class _ZipcodeInputState extends State<_ZipcodeInput> {
  final _controller = TextEditingController();

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
              controller: _controller,
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
    _controller.dispose();
    super.dispose();
  }
}







