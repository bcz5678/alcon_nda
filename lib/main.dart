import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view/view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AlcornNdaApp());
}

class AlcornNdaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => MainBloc(),
        ),
        BlocProvider(
          create: (context) => NDAFormBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Alcon NDA App",
        theme: ThemeData.light(),
        home: HomePage(),
      ),
    );
  }
}