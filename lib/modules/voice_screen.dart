import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifesecret/layout/cubit/lifecubit.dart';
import 'package:lifesecret/layout/cubit/lifestates.dart';

class VoiceScreen extends StatefulWidget {

 const VoiceScreen({Key? key,}) : super(key: key);

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with WidgetsBindingObserver{

 LifeCubit? _cub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        _cub!.testState(url: '', isPused: true);
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }

  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LifeCubit, LifeStates>(
        listener: (context, state){

          LifeCubit cubit = LifeCubit.get(context);
          setState(() {

            _cub = cubit;
          });
          if(state is ChangeInterstitialAdLoadedFalse){
            cubit.audioPlayer!.play(cubit.voiceList[cubit.index].getVoice);
          }
if(state is ChangeInterstitialAdLoadedTrue){
  cubit.audioPlayer!.play(cubit.voiceList[cubit.index].getVoice);
}
          if(state is SetDurationEvent){
            cubit.audioPlayer!.play(cubit.voiceList[cubit.index].getVoice);          }
        },
      builder: (context, state){
        LifeCubit cubit = LifeCubit.get(context);


        ////////////////////////////////// setStatusBarColor transparent, ///////////////////
        setStatusBarColor();
        print('builder in voice secreen');
        ////////////////////////////////// setStatusBarColor transparent, ///////////////////
        return WillPopScope(
      onWillPop: () async {
        cubit.refreshAudioPlayer();
        print("After clicking the Android Back Button");
          return true;
        },
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body:voiceBody(cubit: cubit),
            //voiceBody(cubit: cubit) ,
          ),
        );
      },
    );

  }
}
 void setStatusBarColor(){
   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
     statusBarColor: Colors.transparent,
   ));
 }

 Widget voiceBody({required LifeCubit cubit}){
  return Container(

    child: InkWell(
      onTap: (){
        print('pause//////////////////////////////////////////');
       // cubit.audioPlayer.pause();
        cubit.testState(url: cubit.voiceList[cubit.index].getVoice);


      },
      child: Stack(
        // textDirection: TextDirection.rtl,

        alignment: AlignmentDirectional.center,
        children: [

          ScrollImage(cubit: cubit),

          Carizmatexts(cubit: cubit),

          if(!cubit.isPlay)
          ButtonPlay(),
         // CarizmaBackGround(),
          mySlider(cubit: cubit),
        ],
      ),
    ),
  );
 }

Widget mySlider({required cubit}){
  return Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        // color: Colors.white,
        height: 100,

        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(

            children: [
              Container(
                alignment: AlignmentDirectional.center,
                width: 70,
                height: 20,
                color: Colors.black,
                child: Text(cubit.handlePosition(cubit.position), style: TextStyle(fontFamily: '',color: Colors.white,fontWeight: FontWeight.bold),),
              ),


              Row(
                children: [

                  if(cubit.loading)
                    loadingS(),

                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        thumbColor: Colors.green,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                        //overlayShape: RoundSliderOverlayShape(overlayRadius: 30.0),
                      ),
                      child: Slider(

                        min: 0.0,
                        max: cubit.duration.inSeconds.toDouble(),
                        value: cubit.position.inSeconds.toDouble(),
                        activeColor: Colors.amber,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.redAccent,
                        onChanged: (double value){
                          print(value);
                          print(value.toInt());
                          cubit.changeToInt(value.toInt());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

        ),
      ),
    ),
  );

}

Widget loadingS(){
  return Align(
      alignment: AlignmentDirectional.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 7),
        child: Container(
            height: 15,
            width: 15,
            child: CircularProgressIndicator()),
      ));
}

Widget CarizmaBackGround (){
  return  Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          colors: [
            Color(0xff613C7D),

            Color(0xff6077B1),

          ],
          begin: AlignmentDirectional.topCenter,
          end: AlignmentDirectional.bottomCenter
      ),

    ),
  );
}

Widget ScrollImage({required LifeCubit cubit}){

  return  SingleChildScrollView(
   // physics : NeverScrollableScrollPhysics(),
    controller: cubit.scrollController,
    reverse: true,
    scrollDirection: Axis.horizontal,
    child: Container(
      width: 1500,
      height: double.infinity,
      // duration: Duration(seconds: 2),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(cubit.voiceList[cubit.index].getImage),
        ),
      ),
    ),
  );
}

Widget Carizmatexts({required LifeCubit cubit}){
  return Align(
    alignment: AlignmentDirectional.topStart,
    child: Padding(
      padding: const EdgeInsets.only(top: 50,right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container( color: Colors.black87,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('سر الحياة', style: TextStyle(color: Colors.white,fontSize: 20),),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),

            color: Colors.black87,
            child: Text(cubit.voiceList[cubit.index].getTitle,style: TextStyle(color: Colors.grey.shade300, fontSize: 20,),),),
        ],
      ),
    ),
  );
}

Widget ButtonPlay(){
  return const AnimatedOpacity(
    duration: Duration(seconds: 2),
    opacity: 1,
    child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.black87,
        child: Icon(Icons.play_arrow, size: 37,color: Colors.white, )),
  );
}