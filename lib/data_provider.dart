import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:subgkart_delivery/data.dart';

class DataProvider{

  final db=Firestore.instance;

  Stream<QuerySnapshot>order(){
    return db.collection('Orders').where('deliveryBoy',isEqualTo: UserAuth.user.uid).where('status',isEqualTo: 'Order PickedUp').snapshots();
  }

  Stream<QuerySnapshot>boyOrders(){
    return db.collection('Orders').where('status',isEqualTo: 'Order Completed').where('deliveryBoy',isEqualTo: UserAuth.user.uid).snapshots();
  }

  Stream<QuerySnapshot>orderItems(String id){
    return db.collection('Items').where('orderID',isEqualTo: id).snapshots();
  }

  Stream<DocumentSnapshot>orderDetails(String doc){
    return db.collection('Orders').document(doc).snapshots();
  }

  Stream<DocumentSnapshot>profile(String doc){
    return db.collection('Employee').document(UserAuth.user.uid).snapshots();
  }

}

DataProvider dataProvider=new DataProvider();