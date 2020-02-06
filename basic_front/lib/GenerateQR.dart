import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Storage.dart';

class QRPage extends StatefulWidget {
  QRPage({Key key, this.token}) : super(key: key);

  final String token;

  @override
  QRState createState() => QRState();
}

class QRState extends State<QRPage>
{
  Storage storage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage = new Storage();
  }

  @override
  Widget build (BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return Scaffold (
          appBar: new AppBar(
            title: new Text("QR Code"),
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
                    FutureBuilder(
                        future: storage.readToken(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return new Text('Issue Posting Data');
                            case ConnectionState.waiting:
                              return new Center(child: new CircularProgressIndicator());
                            case ConnectionState.active:
                              return new Text('');
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text("Error");
                              } else {
                                return QrImage(
                                  data: snapshot.data,
                                  version: QrVersions.auto,
                                  size: 320,
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
                                );
                              }
                              break;
                            default:
                              return null;
                          }
                        }
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