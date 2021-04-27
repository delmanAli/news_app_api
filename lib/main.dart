import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softagi_2021/layout/cubit/cubit.dart';
import 'package:softagi_2021/layout/news_app/cubit/cubit.dart';
import 'package:softagi_2021/layout/news_app/cubit/states.dart';
import 'package:softagi_2021/layout/news_app/news_layout.dart';
import 'package:softagi_2021/shared/bloc_observer.dart';
import 'package:softagi_2021/shared/network/local/cach_helper.dart';
import 'package:softagi_2021/shared/network/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  DioHelper.init();
  await CacheHelper.init();

  var isDark = CacheHelper.getData(
    key: 'isDark',
  );

  var countryCode = CacheHelper.getData(
    key: 'countryCode',
  );

  print(isDark);

  // run my app method
  // param is object from Widget class
  runApp(
    MyApp(
      isDark: isDark,
      countryCode: countryCode,
    ),
  );
}

// 1. stateless
// 2. stateful

// main class extends widget
class MyApp extends StatelessWidget {
  // main method of class to build screen UI
  final bool isDark;
  final String countryCode;

  MyApp({
    this.isDark,
    this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    // material app object wrap all screens
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => TodoCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => NewsCubit()
            ..setDataFromSharedPreferences(
              fromShared: isDark,
              savedCountryCode: countryCode,
            )
            ..getBusiness()
            ..getSports()
            ..getScience(),
        ),
      ],
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Jannah',
              primarySwatch: Colors.teal,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
              ),
              textTheme: TextTheme(
                subtitle1: TextStyle(
                  fontSize: 18.0,
                  height: 1.5,
                ),
              ),
            ),
            darkTheme: ThemeData(
              scaffoldBackgroundColor: Colors.white12,
              fontFamily: 'Jannah',
              primarySwatch: Colors.teal,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white12,
              ),
              textTheme: TextTheme(
                subtitle1: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
            themeMode: NewsCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: NewsHomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
