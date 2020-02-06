import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends StatefulWidget {
  QRPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  QRState createState() => QRState();
}

class QRState extends State<QRPage>
{

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 200,
              ),
              child: Center (
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    QrImage(
                      data: widget.title,
                      version: 1,
                      size: 320,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          child: Center(
                            child: Text(
                              "Uh oh! Something went wrong...",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ),
          ),
        );
      },
    );
  }
}