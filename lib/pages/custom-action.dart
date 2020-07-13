import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  final Function onAcceptPressed, onDecinePressed, onReschedulePressed;
  final String value1;
  final String value2;
  bool isLoading = false;
  final bool visible;
  CustomActionButton(
      {Key key,
      @required this.onAcceptPressed,
      @required this.onReschedulePressed,
      @required this.onDecinePressed,
      this.value1,
      this.value2,
      this.visible,
      this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22, bottom: 8),
      child: Visibility(
        visible: visible,
        child: Container(
          height: SizeConfig.safeBlockVertical * 10,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: SizeConfig.safeBlockVertical * 6.6,
                  child: RaisedButton(
                    disabledElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: isLoading
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Text(
                            value1 ?? 'Accept',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                    onPressed: onAcceptPressed,
                  ),
                ),
              ),
              SizedBox(
                width: 3,
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: SizeConfig.safeBlockVertical * 6.6,
                  child: RaisedButton(
                      disabledElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textColor: Colors.black26,
                      color: Color(0xffEBEFFB),
                      child: Text(
                        're-schedule',
                        style: TextStyle(
                          color: Color(0xff878FA6),
                          fontSize: 16,
                        ),
                      ),
                      onPressed: onReschedulePressed),
                ),
              ),
              if (value1 != 'review link')
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: SizeConfig.safeBlockVertical * 6.6,
                    child: RaisedButton(
                        disabledElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        textColor: Colors.black26,
                        color: Colors.redAccent,
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: onDecinePressed),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
