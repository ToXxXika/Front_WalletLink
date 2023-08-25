import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallet_link/pages/m_y_card/m_y_card_widget.dart';
import 'package:wallet_link/pages/profilepage/profilepage_widget.dart';

import '../pages/home_page/home_page_widget.dart';

class Caller {
  void initState(BuildContext context) {}

  Future<bool> register(
      String mail, String password, String cin, BuildContext context) async {
    print(mail);
    print(password);
    print(cin);
    try {
      final Uri uri = Uri.http("192.168.1.22:8081", '/user/register',
          {'email': mail, 'mdp': password, 'cin': cin});
      final response = await http.post(uri);
      print(response.body);
      final decodedResponse = json.decode(response.body);
      if (decodedResponse["code"] == 200) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilepageWidget()));
        //save response.body in shared preferences
        return true;
      } else {
        AlertDialog(
          title: Text('Error'),
          content: Text('Account Not Created'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        );
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> LoadBankAccountsData(String cin) async {
    try {
      final Uri uri =
          Uri.http('192.168.1.22:8081', '/wallet/gad', {'cin': cin});
      final response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      if (decodedResponse["code"] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Rib', decodedResponse["account"]["rib"] ?? '');
        prefs.setString(
            'balance', decodedResponse["account"]["balance"]?.toString() ?? '');
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> LoadWalletData(String cin) async {
    try {
      final Uri uri =
          Uri.http('192.168.1.22:8081', '/wallet/gwd', {'cin': cin});
      final response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      if (decodedResponse["code"] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('balanceWallet',
            decodedResponse["wallet"]["balance"]?.toString() ?? '');
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> verifyCredentials(
      String email, String password, BuildContext context) async {
    try {
      final Uri uri = Uri.http('192.168.1.22:8081', '/user/login',
          {'email': email, 'mdp': password});
      final response = await http.post(uri);
      final decodedresponse = json.decode(response.body);
      print(decodedresponse);
      if (decodedresponse["code"] == 200) {
        //save response.body in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('nom', decodedresponse["user"]["nom"] ?? 'USER');
        prefs.setString('prenom', decodedresponse["user"]["prenom"] ?? 'USER');
        prefs.setString('cin', decodedresponse["user"]["cin"] ?? '');
        prefs.setString('email', decodedresponse["user"]["email"] ?? 'EMAIL');
        prefs.setString('refWallet',
            decodedresponse["user"]["walletsByCin"]["refWallet"] ?? '');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomePageWidget()));
        return true;
      } else {
        //show error message
        print("Password or mail wrong");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Password or mail wrong'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ],
              );
            });

        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> EditProfile(String cin ,String email,String phone,BuildContext context) async {
    try{
      final Uri uri = Uri.http('192.168.1.22:8081','/user/edit',{'cin':cin,'email':email,'phone':phone});
      final response = await http.post(uri);
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      if(decodedResponse["code"]== 200){
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile Updated'),
            duration: Duration(seconds: 2),
          ),
        );
         initState(context);
      }
    }catch(e){
      print(e);
    }
    return false ;
  }

  Future<bool> fundwallet(
      String cin, String cash, String wallet, BuildContext context) async {
    try {
      final Uri uri = Uri.http('192.168.1.22:8081', '/wallet/fw',
          {'cin': cin, 'cash': cash, 'walletref': wallet});
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wallet Funded'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MYCardWidget()));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error'),
            duration: Duration(seconds: 2),
          ),
        );
        //show error message

        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> peer2peer(String Sender, String Receiver, double amount,
      BuildContext context) async {
    try {
      print("Sender :" + Sender + "\n");
      print("Receiver" + Receiver + "\n");
      print("Amount" + amount.toString() + "\n");

      final Uri uri = Uri.http('192.168.1.22:8081', 'wallet/transfer', {
        'sender': Sender,
        'receiver': Receiver,
        'amount': amount.toString()
      });
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getWalletDetails(String cin, BuildContext context) async {
    try {
      final Uri uri =
          Uri.http('192.168.1.22:8081', '/wallet/get', {'cin': cin});
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        final decodedBod = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('walletDetails', decodedBod);
        AlertDialog(
          title: Text('Success'),
          content: Text('Wallet Details'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> getTransactions(String cin) async {
    print("CIN" + cin);

    try {
      final Uri uri =
          Uri.http('192.168.1.22:8081', '/transaction/get', {'cin': cin});
      final response = await http.get(uri);
      final decodedBod = json.decode(response.body);
      print(decodedBod);
      if (decodedBod["status"] == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'transactions', json.encode(decodedBod["transactions"]));
        prefs.setInt("Count", decodedBod["count"]);
        //* print(decodedBod["transactions"]);
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransactionADDWidget()));
        */
        return true;
      }
    } catch (e) {
      print("EXCEPTION");
      print(e);
      return false;
    }
    return false;
  }
}
