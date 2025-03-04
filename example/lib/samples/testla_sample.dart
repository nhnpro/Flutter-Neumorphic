import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TeslaSample extends StatefulWidget {
  @override
  createState() => _TeslaSampleState();
}

class _TeslaSampleState extends State<TeslaSample> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: Color(0xFF30353B),
        intensity: 0.3,
        accentColor: Color(0xFF0F95E6),
        lightSource: LightSource.topLeft,
        depth: 2,
      ),
      child: Scaffold(
        body: SafeArea(
          child: NeumorphicBackground(child: _PageContent()),
        ),
      ),
    );
  }
}

class _PageContent extends StatefulWidget {
  @override
  __PageContentState createState() => __PageContentState();
}

class __PageContentState extends State<_PageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF373C43),
            Color(0xFF17181C),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTopBar(context),
          Expanded(
              flex: 2,
              child: _buildTitle(context)
          ),
          Expanded(
              flex: 5,
              child: _buildCenterContent(context)
          ),
           _buildBottomAction(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: NeumorphicButton(
              onClick: (){
                Navigator.of(context).pop();
              },
              border: NeumorphicBorder(
                shape: NeumorphicShape.concave,
                width: 2,
                color: Color(0xFF111111),
              ),
              boxShape: NeumorphicBoxShape.circle(),
              style: NeumorphicStyle(
                color: Color(0xFF17181C),
                depth: 8,
                intensity: 0.3,
                shape: NeumorphicShape.convex,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: NeumorphicButton(
              border: NeumorphicBorder(
                shape: NeumorphicShape.concave,
                width: 2,
                color: Color(0xFF111111),
              ),
              boxShape: NeumorphicBoxShape.circle(),
              style: NeumorphicStyle(
                color: Color(0xFF17181C),
                depth: 8,
                intensity: 0.3,
                shape: NeumorphicShape.convex,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Tesla",
          style: TextStyle(
            color: Colors.white30,
          ),
        ),
        Text(
          "CyberTruck",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCenterContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "297",
              style: TextStyle(color: Colors.white, fontSize: 120, fontWeight: FontWeight.w200),
            ),
            Text(
              "km",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: SizedBox(
            height: 280,
            child: Padding(
              padding: EdgeInsets.only(top: 35),
              child: Image.asset(
                "assets/images/tesla_cropped.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: Column(
        children: <Widget>[
          Text(
            "A/C is turned on",
            style: TextStyle(
              color: Colors.white30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          NeumorphicButton(
            onClick: (){

            },
            boxShape: NeumorphicBoxShape.circle(),
            border: NeumorphicBorder(
              shape: NeumorphicShape.flat,
              width: 3,
              color: NeumorphicTheme.accentColor(context),
            ),
            style: NeumorphicStyle(
              depth: 10,
              color: NeumorphicTheme.accentColor(context),
              shape: NeumorphicShape.concave,
            ),
            child: SizedBox(
              height: 80,
              width: 80,
              child: Icon(
                Icons.lock,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Tap to open the car",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
