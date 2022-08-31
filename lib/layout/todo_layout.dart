import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
 import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';




 import '../../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();

  var titleControllar=TextEditingController();
  var timeControllar=TextEditingController();
  var dateControllar=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }

        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit=AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            body:ConditionalBuilder (
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex] ,
              fallback: (context) =>Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()  {
                if(cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){
                    cubit.insertDatabase(title: titleControllar.text, time: timeControllar.text, date: dateControllar.text);


                  }

                }else{
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) =>Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0,),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField  (
                              lable: 'Task Title',
                              controller:titleControllar ,
                              validate: (String? value ) {
                                if(value!.isEmpty){
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              Type:TextInputType.text     ,
                              prefix:  Icons .title ,
                            ),
                            SizedBox(
                              height: 15.0,
                            )
                            ,
                            defaultFormField  (
                              lable: 'Task time',
                              controller:timeControllar ,


                              validate: (String? value ) {
                                if(value!.isEmpty){
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              Type:TextInputType.datetime    ,
                              onTap: (){
                                showTimePicker(
                                  context: context ,
                                  initialTime: TimeOfDay.now(),).then((value) {
                                  timeControllar.text =value!.format(context ).toString();
                                  print(value.format(context ));
                                });
                              },
                              prefix:  Icons .title ,


                            ),  SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField  (
                              lable: 'Task date',
                              controller:dateControllar ,


                              validate: (String? value ) {
                                if(value!.isEmpty){
                                  return 'date must not be empty';
                                }
                                return null;
                              },
                              Type:TextInputType.datetime    ,
                              onTap: (){
                                showDatePicker(
                                  context:context,
                                  initialDate:  DateTime.now() ,
                                  firstDate: DateTime.now() ,
                                  lastDate:  DateTime.parse('2023-01-01'),).then((value) {

                                  dateControllar.text=DateFormat.yMMMd().format(value!);



                                });

                              },
                              prefix:  Icons.calendar_today ,


                            ),

                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value)
                  {
                    cubit.ChangeBottomSheetState(isShow: false, icon: Icons.edit,);


                  });
                  cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add,);
                }




              },
              child: Icon(
                cubit.fapIcon,
              ),

            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:cubit. currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
                print(index);
              },
              items:
              [BottomNavigationBarItem(icon: Icon(
                Icons.menu,

              ),
                label: 'Tasks',

              ),
                BottomNavigationBarItem(icon: Icon(
                  Icons.check_circle_outline,

                ),
                  label: 'Done',

                ),
                BottomNavigationBarItem(icon: Icon(
                  Icons.archive_outlined ,

                ),
                  label: 'Archived',

                ),

              ],
            ),
          );
        },

      ),
    );
  }
  //Future<String> getName()async {
  //  return 'nada gamal';
  // }

}
