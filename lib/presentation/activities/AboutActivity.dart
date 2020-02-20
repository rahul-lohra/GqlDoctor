import 'package:flutter/material.dart';

class AboutActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(children: <Widget>[
        Text("Version: 1.0.0", style: TextStyle(fontSize: 16), textAlign: TextAlign.left,),
        SelectableText("Contribute here: https://github.com/rahul-lohra/GqlDoctor", style: TextStyle(fontSize: 16),)
      ],
        crossAxisAlignment: CrossAxisAlignment.start,),);
  }

}