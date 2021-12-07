import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifesecret/layout/cubit/lifestates.dart';
import 'package:lifesecret/models/voices.dart';
import 'package:lifesecret/modules/voice_screen.dart';



class LifeCubit extends Cubit<LifeStates> {
  LifeCubit() : super(InitialLifeState());

  static LifeCubit get(context) => BlocProvider.of(context);


  bool _isPlay = true;
  ScrollController _scrollController =ScrollController();
  Duration _position = Duration();
  Duration _duration = Duration();
  AudioPlayer? audioPlayer =AudioPlayer();
  String? _url;
  bool _loading= true;
  bool _firstTime = true;
  bool _isInterstitialAdLoaded = false;
  BuildContext? context;
   int? _index;

   ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////
  ////////////////////////////// getter and setter ///////////////////////////

  get isPlay => _isPlay;
  get scrollController => _scrollController;
  get position => _position;
  get duration => _duration;
  get url => _url!;
  get loading => _loading;
  get firstTime => _firstTime;
  get index => _index;



  set firstTime (dynamic firstTime){
    _firstTime = firstTime;
  }

  void setContext(BuildContext context){
    this.context = context;
  }

  set setIndex(int index){
    _index = index;
    emit(SetIndex());
  }

  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////
  ////////////////////////////// close ///////////////////////////


  @override
  Future<void> close() {
    audioPlayer!.pause().then((value) {
      audioPlayer!.dispose();
      _scrollController.dispose();
    });
   print ('audio dispose');
    return super.close();
  }





  ///////////////////////////////// ads //////////////////////////////
  ///////////////////////////////// ads //////////////////////////////
  ///////////////////////////////// ads //////////////////////////////
  ///////////////////////////////// ads //////////////////////////////

  void loadInterstitialAd() {
    FacebookAudienceNetwork.init(
      testingId: "b9f2908b-1a6b-4a5b-b862-ded7ce289e41",
    );


    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED){

            _isInterstitialAdLoaded = true;

         emit(ChangeInterstitialAdLoadedTrue());
        }


        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          if(!_isInterstitialAdLoaded){
            Navigator.push(
                context!,
                MaterialPageRoute(
                    builder: (context){
                      return VoiceScreen();
                    }));
            emit(ChangeInterstitialAdLoadedFalse());
          }
         // testState(url: '');
          loadInterstitialAd();

        }
      },
    );
  }

  showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else {
      print("Interstial Ad not yet loaded!");
      Navigator.push(
          context!,
          MaterialPageRoute(
              builder: (context) {
                return VoiceScreen();
              }));
    }
  }


  showBannerAd() {

      currentAd = FacebookBannerAd(
        // placementId: "YOUR_PLACEMENT_ID",
        placementId:
        "IMG_16_9_APP_INSTALL#2312433698835503_2964944860251047", //testid
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          print("Banner Ad: $result -->  $value");
        },
      );
       emit(ChangeCurrentAd());
  }


  Widget currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );


////////////////// audio player ///////////////////////
////////////////// audio player ///////////////////////
////////////////// audio player ///////////////////////

  void refreshAudioPlayer(){
    audioPlayer!.pause().then((value) {
        audioPlayer!.dispose().then((value) {
        _firstTime = true;
        _loading = true;
        _position = Duration();
        _duration = Duration();
        _isPlay = true;
        _scrollController =ScrollController();
        audioPlayer = AudioPlayer();
        emit(RefreshAudioPlayer());
      });
    });
  }



  void initState({required String url}){
    //audioPlayer = AudioPlayer();
    this._url = url;
      //write or call your logic
      //code will run when widget rendering complete

        audioPlayer!.setUrl(url);


      audioPlayer!.onPlayerCompletion.listen((event) {

       if(_scrollController.hasClients){
       _scrollController.animateTo(_scrollController.position.pixels, duration:  Duration(milliseconds: 100), curve: Curves.linear);
       changeIsPlay(false);
       changeToInt(0);
      }
      });

      audioPlayer!.onAudioPositionChanged.listen((event) {

      //  print(event.inSeconds);

        if(event.inSeconds <= duration.inSeconds){
          //position = event;

          if(position.inSeconds >=0){
            changeLoading(false);
            setPositionEvent(event);

          }
        }

        if(position.inSeconds >=0){
          if(firstTime){
            if(_scrollController.hasClients){
              _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: duration, curve: Curves.linear);
               print('///////////////////////////////////////////////////////////////////////////////////////////');
              print('///////////////////////////////////////////////////////////////////////////////////////////');
              print('///////////////////////////////////////////////////////////////////////////////////////////');
              print('///////////////////////////////////////////////////////////////////////////////////////////');
              print('///////////////////////////////////////////////////////////////////////////////////////////');
              changeFirstTime(false);
            }


          }
        }
        //print(position.inSeconds );

      });

      audioPlayer!.onDurationChanged.listen((event) {

        setDurationEvent(event);
      //  print(duration.inSeconds);


      });



  }

  void testState({required String url, bool? isPused}){

    if(isPused != null){

      _scrollController.animateTo(_scrollController.position.pixels, duration: Duration(seconds: 1), curve: Curves.linear).then((value) {
        print(_scrollController.position.pixels);
        audioPlayer!.pause();
        changeIsPlay(false);
      });
    }
    else{
      if(!_isPlay){
        if(_scrollController.hasClients){
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: duration, curve: Curves.linear);
          audioPlayer!.play(url);
          changeIsPlay(true);
          //changeFirstTime(false);
        }
        print('in not is play ///////////////////////');


      }else{
        if(_scrollController.hasClients){
          _scrollController.animateTo(_scrollController.position.pixels, duration: Duration(seconds: 1), curve: Curves.linear).then((value) {
            print(_scrollController.position.pixels);
            audioPlayer!.pause();
            changeIsPlay(false);
          });
    }



      }

      print('in  is play ///////////////////////');

    }

  }


  String handlePosition(Duration position){

    String strPosition = position.toString();
    strPosition = strPosition.split('.')[0];

    if(strPosition[0].contains('')){
      if(strPosition[1].contains(':')){
        strPosition = strPosition.replaceFirst(':', '');
      }
    }

    if(strPosition[0].contains('0')){
      strPosition = strPosition.replaceFirst('0', '');
    }
    if(strPosition[0].contains(':') && strPosition[1].contains('0')){
      strPosition = strPosition.replaceFirst(':', '');
      strPosition = strPosition.replaceFirst('0', '');
    }

    //strPosition = strPosition.split(':0')[1];

    return strPosition;
  }

  void changeToInt(int second){
    // second = second-2;

    Duration newDuration = Duration(seconds: second);
    if(_isPlay) {
      audioPlayer!.seek(newDuration).then((value) {
        double result = position.inSeconds / duration.inSeconds;
        result = result * _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
            result, duration: Duration(milliseconds: 100), curve: Curves.linear)
            .then((value) {
          Duration dur = Duration(seconds: duration.inSeconds - position.inSeconds);
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent, duration: dur,
              curve: Curves.linear);
        });

        // Duration dur = Duration(seconds: duration.inSeconds - position.inSeconds);
        //scrollController.animateTo(scrollController.position.maxScrollExtent, duration:  dur , curve: Curves.linear);
      });
    }else{
      audioPlayer!.seek(newDuration).then((value) {
        _scrollController.jumpTo(1.0);
      });

    }
  }

  void setAudioPause(){
      audioPlayer!.pause().then((value)=>print('done'));
      emit(SetAudioPause());
  }

  void setPositionEvent(Duration event){
    _position= event;
    emit(SetPositionEvent());
  }

void setDurationEvent(Duration event){
    _duration = event;
    emit(SetDurationEvent());
}

  void changeIsPlay(bool isPlay){
    this._isPlay = isPlay;
    emit(ChangeIsPlayState());
  }

  void changeLoading(bool loading){
    if(this.loading){
      this._loading = loading;
      emit(ChangeIsLoadingState());
    }
    // this.loading = loading;
    // emit(ChangeIsLoadingState());

  }

  void changeFirstTime(bool firstTime){
    if(this.firstTime){
      this.firstTime = false;
      emit(ChangeFirstTime());
    }

  }

 //////////////////////// voice data //////////////////////////////
  //////////////////////// voice data //////////////////////////////
  //////////////////////// voice data //////////////////////////////
  //////////////////////// voice data //////////////////////////////

List<VoicesModel> voiceList = [];
  void getVoicesData(){

    FirebaseFirestore.instance.collection('voices').orderBy('time').get().then((value) {

      value.docs.forEach((element) {
       // print(element.data());
        voiceList.add(VoicesModel.fromjson(element.data()));
        //voiceList.last.setVoiceUid = element.id;
         emit(GetDataVoicesSuccess());
      // print('//////////////////////////////////// element ${voiceList.last.getTitle}');
      });
      voiceList.forEach((element) {
        print(element.getTitle);
      });
    }).catchError((onError){
      print('//////////////////////////////////// on error ${onError}');
    });
  }

  void printDataVoice(){
    for(var x =0 ; x< voiceList.length ; x++){
      print(voiceList[x].getTitle);
    }
  }
}
