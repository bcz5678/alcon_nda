import 'package:alcon_flex_nda/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'view/view.dart';


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/step_two',
      builder: (context, state) => StepTwo(),
    ),
    GoRoute(
      path: '/step_three',
      builder: (context, state) => StepThree(),
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Alcon NDA App",
        theme: ThemeData.light(),
        routerConfig: _router,
      ),
    );
  }
}