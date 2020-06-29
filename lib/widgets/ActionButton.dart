import 'package:cssalonapp/widgets/sizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function onAcceptPressed, onDecinePressed;
  final String value1;
  final String value2;
  bool isLoading = false;
  final bool visible;
  ActionButton(
      {Key key,
      @required this.onAcceptPressed,
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
                flex: 3,
                child: SizedBox(
                  height: SizeConfig.safeBlockVertical * 6.6,
                  child: RaisedButton(
                    disabledElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    textColor: Colors.white,
                    color: Colors.blue,
                    child: isLoading
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Text(
                            value1 ?? 'accept',
                            style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 5.5,
                            ),
                          ),
                    onPressed: onAcceptPressed,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      textColor: Colors.black26,
                      color: Color(0xffEBEFFB),
                      child: Text(
                        value2 ?? 'Decline',
                        style: TextStyle(
                          color: Color(0xff878FA6),
                          fontSize: SizeConfig.safeBlockHorizontal * 5,
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
