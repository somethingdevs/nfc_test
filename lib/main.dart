import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

var result;
var tech;
String messages = '';
String ndefPayload = '';
bool isAvailable = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

//Availability Check
Future<void> _available() async {
  isAvailable = await NfcManager.instance.isAvailable();
  print(isAvailable);
}

//Reading NDEF Tag
void _tagRead() {
  NfcManager.instance.startSession(
    onDiscovered: (tag) async {
      var tech = tag.data['ndef']['cachedMessage']['records'][0]['payload'];
      messages = String.fromCharCodes(tech);
      print(messages);
      NfcManager.instance.stopSession();
      print(tag.data);
    },
  );
}

//Write to an NDEF Tag
void _ndefWrite(String payload) async {
  print(payload);
  NfcManager.instance.startSession(
    onDiscovered: (tag) async {
      print('Tag Discovered!');
      var ndef = Ndef.from(tag);
      print('Line works fine!');
      if (ndef == null || !ndef.isWritable) {
        print('Error has occured!');
        result.value = 'Tag is not NDEF writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      NdefMessage message = NdefMessage(
        [
          NdefRecord.createUri(Uri.parse(payload)),
        ],
      );

      //The actual writing part
      try {
        print('Going to write now!');
        print(payload);
        print(message);
        await ndef.write(message);
        // result.value = payload;
        NfcManager.instance.stopSession();
        print(message.records.length);
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tagRead();
                    });
                  },
                  child: Text('Read Tag'),
                ),
                messages.isEmpty ? SizedBox() : Text(messages),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    _ndefWrite(ndefPayload);
                  },
                  child: Text('Write NDEF Tag'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    maxLength: 60,
                    onSubmitted: (value) {
                      setState(() {
                        ndefPayload = value;
                        print(ndefPayload);
                        print('Success!');
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _available();
                    });
                  },
                  child: Text('Availability'),
                ),
                Container(
                  child: Text(isAvailable.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
