
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifesecret/layout/cubit/lifecubit.dart';
import 'package:lifesecret/layout/cubit/lifestates.dart';
import 'package:lifesecret/modules/voice_screen.dart';
import 'package:lifesecret/styles/themes.dart';



class LifeLayout extends StatelessWidget {
  const LifeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LifeCubit, LifeStates>(
        builder: (context , state){
          LifeCubit cubit = LifeCubit.get(context);
          return Scaffold(

              backgroundColor: Colors.white70.withOpacity(0.8),
              appBar: appBarLife(title: 'سر الحياة'),
              body: BlocConsumer<LifeCubit, LifeStates>(
                listener: (context, states){
                  // print('listner /////////////////////////////////// listner //////////');
                },
                builder: (context, states){
                  int width = MediaQuery.of(context).size.width.round();
                  int height = MediaQuery.of(context).size.height.round();

                  return titlesListBody(height: height, context: context, cubit: cubit);
                },
              )

          );
        },
        listener: (context, state){

        });
  }

}
AppBar appBarLife({ required String title}){
  return AppBar(
    title: Text(title, style: TextStyle(fontSize: 30, ),),
    elevation: 0,
    toolbarHeight: 70,
    systemOverlayStyle: const SystemUiOverlayStyle(

      statusBarColor: Colors.pink,
    ),
    flexibleSpace:  Container(
    color: appBarColor,
    ),);
}
AppBar lifeAppBar(){
  return AppBar(
    centerTitle: false,
    backgroundColor: appBarColor,
    title: Text('سر الحياة', style: TextStyle(fontSize: 30, color: Colors.white),),
  );
}


Widget titlesListBody({required int height, required BuildContext context, required LifeCubit cubit}){
  return Column(
    children: [
      Flexible(

        child: ListView.separated(

            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  // height: hie / 5,
                  child: GestureDetector(
                    onTap: (){
                      cubit.setIndex = index;
                      cubit.setContext(context);
                     cubit.showInterstitialAd();
                    cubit.initState(url: cubit.voiceList[index].getVoice);
                    },
                    child: Card(

                      color: Colors.white70,
                      child: Row(
                        children: [
                          SizedBox(width: 10, height: height / 8,),
                          Expanded(child: Text(cubit.voiceList[index].getTitle, style: TextStyle(fontSize: 25),)),
                          //Spacer(),
                          IconButton(
                              onPressed: (){
                                cubit.setIndex = index;
                                cubit.setContext(context);
                                cubit.showInterstitialAd();
                                cubit.initState(url: cubit.voiceList[index].getVoice);
                              },
                              icon: FaIcon(FontAwesomeIcons.play, color: Colors.purple,size: 18,)),
                          SizedBox(width: 20,)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder:(context, index){
              return separatorContainer();
            },
            itemCount: cubit.voiceList.length),
      ),
      Align(
        alignment: Alignment(0, 1.0),
        child: cubit.currentAd,
      )
    ],
  );


}


Widget separatorContainer(){
  return Container(
      height: 0,
      width: double.infinity,
      color: Colors.grey);
}
