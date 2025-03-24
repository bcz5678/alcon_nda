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

  @override
  void initState() {
    _fullNameDisplayMessage = false;
    _titleDisplayMessage = false;
    super.initState();
  }


  void onPressedFooterFunction() {
    var state = context.read<NDAFormBloc>().state;

    if (state.fullNameInputValid! && state.titleInputValid!) {
      context.read<NDAFormBloc>().add(
          NDAFormStepSubmitted(
              nextStep: NDAFormStep.addExperiences));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StepTwo()),
      );
    } else {
      setState(() {
        _fullNameDisplayMessage = state.fullNameInput!.isNotValid;
        _titleDisplayMessage = state.titleInput!.isNotValid;
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
                              widthFactor: 0.35,
                              child: Image(
                                  image: AssetImage('images/alcon-logo-2019.png')
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              "Welcome to {eventName}",
                              style: GoogleFonts.notoSans(
                                textStyle: TextStyle(
                                  color: Colors.black.withAlpha(175),
                                  fontSize: 60.0,
                                  fontWeight: FontWeight.bold,
                                )
                              ),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore.",
                              style: GoogleFonts.notoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black.withAlpha(175),
                                    fontSize: 20.0,
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
                                  fontSize: 32.0,
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
                                        padding: const EdgeInsets.only(top: 20,),
                                        child: _FullNameInput(
                                          displayMessageState: _fullNameDisplayMessage,
                                        ),
                                      ),
                                      _TitleInput(
                                        displayMessageState: _titleDisplayMessage,
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
            child: Text(
              "Full Name",
              style: UITextStyle.labelLarge,
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
                "Title",
                style: UITextStyle.labelLarge,
              ),
            ),
            AppFullNameTextField(
              key: const Key('formInput_step1_titleInput'),
              controller: _controller,
              readOnly: state.formzSubmissionStatus?.isInProgress,
              hintText: "Please enter your title",
              errorText: widget.displayMessageState ? "Please enter a valid title" : null,
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






