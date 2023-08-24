
import 'dart:ffi';

class Transaction {
  late final  String sender ;
  late final  String receiver ;
  late final  double amount ;
  late final String ref_trans ;
  late final String date_trans ;

  Transaction(this.sender,this.receiver,this.amount,this.ref_trans,this.date_trans);
  Transaction.fromJson(Map<String,dynamic> json):sender = json['sender'],receiver=json['receiver']
  ,amount=json["amount"],ref_trans=json["ref_trans"].toString(),date_trans=json["date_trans"].toString();
}