import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifesecret/layout/cubit/lifecubit.dart';
import 'package:lifesecret/layout/cubit/lifestates.dart';
import 'package:lifesecret/layout/life_layout.dart';
import 'package:lifesecret/modules/voice_screen.dart';
import 'package:lifesecret/shared/cach_helper.dart';
import 'package:lifesecret/styles/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'class_bloc/class_bloc.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor:  Colors.black,
    //systemNavigationBarDividerColor: Colors.red,
    systemNavigationBarIconBrightness: Brightness.light,
    //statusBarColor: Colors.pink,
  ));
  WidgetsFlutterBinding.ensureInitialized();


  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  CacheHelper.init().then((value) {
    // token =  CacheHelper.getData(key: 'token');
    //print('data ============ $token');
  });

  runApp( MyApp());
}



class MyApp extends StatelessWidget {
  String? token;
  MyApp({this.token});
  @override
  Widget build(BuildContext context) {
    print('builder');
    return BlocProvider<LifeCubit>(
      create: (context) {
        print('in bloc');
        return LifeCubit()..getVoicesData()..loadInterstitialAd()..showBannerAd();
      },
      child: BlocConsumer<LifeCubit, LifeStates>(
        listener: (context, state){},
        builder: (context, state){
          return Builder(
              builder: (context) => MaterialApp(
                title: 'سر الحياة',
                theme: LifeTheme,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
// 'ar', 'AE
                supportedLocales: const [
                  Locale('ar', ''),
                ],

                home: LifeLayout(),




//CarizmaLayout (token: token,),
              )); },
      ),
    );
  }
}