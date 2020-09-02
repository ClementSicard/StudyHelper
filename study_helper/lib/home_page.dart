import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: customTextStyle(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome back to StudyHelper !',
                textAlign: TextAlign.center,
                style: customTextStyle(
                  size: 30,
                ),
              ),
              SizedBox(height: 60),
              RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.orange,
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Continue studying",
                    style: customTextStyle(
                      color: Colors.white,
                      fw: FontWeight.w100,
                    ),
                  ),
                  height: 200,
                  width: 300,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
