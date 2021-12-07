
class VoicesModel {
  VoicesModel();

  String? _title;
  String? _time;
  String? _voiceUid;
  String? _voice;
  String? _image;


  VoicesModel.setValues({ String? title, String? time, String? voice, String? image }){
     _title = title;
    _time = time;
    _voice = voice;
    _image = image;
  }


  String get getTitle => _title!;
  String get getTime => _time!;
  String get getVoiceUid => _voiceUid!;
  String get getVoice => _voice!;
  String get getImage => _image!;


  set setVoiceUid(String value) {
    _voiceUid = value;
  }

  VoicesModel.fromjson(Map<String, dynamic> json) {

    _title = json['title'];
    _time = json['time'];
    _voice = json['voice'];
    _image = json['image'];
  }

  Map<String ,dynamic > toMap (){

    Map<String ,dynamic > myMap = {};


    myMap ['title'] = _title ;
    myMap ['time'] = _time;
    myMap ['voice'] = _voice;
    myMap ['image_hor'] = _image;

    return myMap;

  }


}
