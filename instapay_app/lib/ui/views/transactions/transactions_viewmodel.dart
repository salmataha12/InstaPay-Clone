import 'package:flutter/material.dart';

class TransactionsViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> transactions = [
    {
      "amount": "50 EGP",
      "name": "mernataha178@instapay",
      "maskedName": "ميرنا طه عبدالعليم العرابي حماد",
      "type": "Received Money",
      "date": "19 Mar 2026 03:34 AM",
      "status": "Successful"
    },
    {
      "amount": "650 EGP",
      "name": "Kareem Hifnawy",
      "maskedName": "KAREEM T**** M****** S***",
      "type": "Send Money",
      "date": "19 Mar 2026 03:19 AM",
      "status": "Successful"
    },
    {
      "amount": "225 EGP",
      "name": "ميرو حبيبتي ❤️❤️",
      "maskedName": "***ميرنا ط* ع****** ا******** ح",
      "type": "Send Money",
      "date": "19 Mar 2026 03:14 AM",
      "status": "Successful"
    },
    {
      "amount": "580 EGP",
      "name": "mernataha178@instapay",
      "maskedName": "ميرنا طه عبدالعليم العرابي حماد",
      "type": "Received Money",
      "date": "11 Mar 2026 02:09 PM",
      "status": "Successful"
    },
    {
      "amount": "70 EGP",
      "name": "01028973355",
      "maskedName": "ايهاب م*** ع******* ح**",
      "type": "Send Money",
      "date": "02 Mar 2026 08:54 PM",
      "status": "Successful",
    },
  ];
}
