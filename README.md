# nfc_test

Testing out NFC with Flutter

# Pakcages using

nfc_manager: ^3.1.0 - https://pub.dev/packages/nfc_manager

There is very little online resources available for NFC using Flutter so it might be a bit tough but I think it's sorta doable.

NDEF - NFC Data Exchange Format. Used to encapsulate typed data. It defines messages and records.

There is a structure to NDEF


This is sorta what it looks like.

As shown above, it has all of the config in the map. The main thing we are concerned with is the message to read. Where is that? That is in the payload. Does that payload look like a weird array or list of numbers? Yes, thats exactly it. Turns out the message is stored in the form of Uint8(8-bit unsigned integer (range: 0 through 255 decimal)). To be able to read this message the payload has to be converted from Uint8 to a normal String. Another interesting thing is on the NDEF payload when you convert it is a weird symbol along with en. To know more about that https://stackoverflow.com/questions/7917567/strange-character-on-android-ndef-record-payload 

Since there isnt much to go on with, I would suggest using https://github.com/okadan/nfc-manager(its what helped me). Download the app as well and follow along with the repo if needed.


# Might also be able to use this package(havent tried)

flutter_nfc_kit: ^3.2.0 - https://pub.dev/packages/flutter_nfc_kit
