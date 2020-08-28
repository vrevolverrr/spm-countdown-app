import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spm_countdown/main.dart';
import 'package:spm_countdown/widgets/alert_dialog_widget.dart';

class QuoteWidget extends StatefulWidget {

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  Future<Map> _quoteFuture;
  String _quoteString = '';

  Future<Map> fetchQuoteData() async {
    if (quoteData == null) {

      try {
        DocumentSnapshot _quoteData = await Firestore.instance.collection('quotes').document('quoteOTD').get();
        quoteData = _quoteData.data;

        return quoteData;

      } catch (e) {
        return null;
      }


    } else {
      return quoteData;
    }
  }

  Future<bool> onPop() async {
    return false;
}

  @override
  void initState() {
    _quoteFuture = fetchQuoteData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _quoteFuture,
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null ) {
            if (snapshot.data['version'] != appVersion) {
              Future.delayed(Duration.zero, () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: onPop,
                        child: customAlertDialog(
                            title: 'Update Available',
                            content: 'Please update the app!'
                        )
                      );
                    }
                );
              });

            } else {
              _quoteString = '"${snapshot.data['quote']}"\n\n- ${snapshot.data['author']}';
            }

          } else {
            _quoteString = 'Failed to connect';
          }
        }
        return Container(
          alignment: Alignment.center,
          height: 150,
          margin: EdgeInsets.only(
              top: 50,
              left: 30,
              right: 30
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(242, 243, 246, 1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromRGBO(5, 5, 5, 0.05),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: Offset(10, 10)
                ),
                BoxShadow(
                    color: Color.fromRGBO(255, 255, 255, 0.8),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: Offset(-10, -10)
                )
              ]
          ),
          child: Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20
            ),
            child: (_quoteString != '') ? Text(
              _quoteString,
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5,
                  fontSize: 14,
                  color: Colors.grey[600],
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600
              ),
            ) : SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }
}