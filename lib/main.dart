import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

var result;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

void _tagRead() {
  NfcManager.instance.startSession(
    onDiscovered: (tag) async {
      result.value = tag.data;
      print(result.toString());
      NfcManager.instance.stopSession();
    },
  );
}

void _ndefWrite() {
  NfcManager.instance.startSession(
    onDiscovered: (tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not NDEF writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      NdefMessage message = NdefMessage(
        [
          NdefRecord.createText('joe nuts'),
        ],
      );

      //The actual writing part
      try {
        await ndef.write(message);
        result.value = 'Sucess!';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('NFC Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _tagRead,
                child: Text('Read Tag'),
              ),
              ElevatedButton(
                onPressed: _ndefWrite,
                child: Text('Write NDEF Tag'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
