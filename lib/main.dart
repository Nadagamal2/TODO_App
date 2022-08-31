import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo_layout.dart';

import 'shared/styles/themes.dart';


void main()
{
  runApp(MyApp());
}


class MyApp extends StatelessWidget
{

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home:  HomeLayout(),
    );
  }
}