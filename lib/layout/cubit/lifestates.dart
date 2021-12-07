abstract class LifeStates {}

class InitialLifeState extends LifeStates {}

class FirstlMainState extends LifeStates {}

class ChangeIsPlayState extends LifeStates {}

class ChangeIsLoadingState extends LifeStates {}

class ChangeFirstTime extends LifeStates {}

class SetDurationEvent extends LifeStates {}


class SetPositionEvent extends LifeStates {}

class SetAudioPause extends LifeStates {}



class RefreshAudioPlayer extends LifeStates {}

class ChangeCurrentAd extends LifeStates {}



class ChangeInterstitialAdLoadedTrue extends LifeStates {}

class ChangeInterstitialAdLoadedFalse extends LifeStates {}

class GetDataVoicesSuccess extends LifeStates {}

class SetIndex extends LifeStates {}