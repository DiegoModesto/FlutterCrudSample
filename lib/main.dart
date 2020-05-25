import 'package:crudsample/provider/UserProvider.dart';
import 'package:crudsample/routes/AppRoutes.dart';
import 'package:crudsample/views/home_view/HomeView.dart';
import 'package:crudsample/views/user_form/UserFormView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(CrudSample());

class CrudSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          AppRoutes.HOME: (_) => HomeView(),
          AppRoutes.USER_FORM: (_) => UserFormView()
        },
      ),
    );
  }
}
