import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
const String _documentPath = 'assets/PDF/eb.pdf';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Prospecting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> prepareTestPdf() async {
    final ByteData bytes =
    await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';
    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children:[
          Expanded(
            flex: 10,
           child: Container(
             decoration: BoxDecoration(
               image: DecorationImage(
                   image: AssetImage('assets/images/PowerProspecting.jpg'),
                   fit: BoxFit.contain),
             ),
           ),
          ),
          Expanded(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => {
                    // We need to prepare the test PDF, and then we can display the PDF.
                    prepareTestPdf().then((path) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPdfViewerScreen(path)),
                      );
                    })
                  },
                  color: HexColor("#d7a23e"),
                  textColor: Colors.white,
                  child: const Text('Power Prospecting',style: TextStyle(fontSize: 25)),
                  elevation: 5,
                ),
              ],
            ),
          )
        ]
      ),

    ));
  }
}

class FullPdfViewerScreen extends StatelessWidget {
  final String pdfPath;
  FullPdfViewerScreen(this.pdfPath);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Will Harris"),
          backgroundColor: HexColor("#d7a23e"),

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
          ],
        ),
        path: pdfPath,

    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        backgroundColor: HexColor("#d7a23e"),
      ),
      body: Container(
        child: Column(

          children: <Widget>[
            Image.asset('assets/images/willharris.JPG'),
            Expanded(

              child:Text('will@willpowerharris.com',style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child: Text('855-669-8226',style: TextStyle(fontSize: 20)),
            )

          ],
        )

      )

    );
  }
}
