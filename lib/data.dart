
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


class UserAuth{
  static FirebaseUser user;
  FirebaseAuth auth=FirebaseAuth.instance;

  static getUser(){
    FirebaseAuth.instance.onAuthStateChanged.listen((event) {
      if(event!=null){
       user=event;
      }
    });
  }
}
class Regions{
  String location;
  String region;
  int pinCode;
  int delivery;
  Regions(this.location, this.region,this.pinCode,this.delivery);
}

class Categories{
  String name;
  String image;
  String icon;
  String tag;
  List<dynamic>tags;
  Categories(this.name, this.image, this.icon,this.tag,this.tags);
}

class Slides{
  String tag;
  String image;

  Slides(this.tag, this.image);
}

class Product{
  String tag;
  List<dynamic>tags;
  List<dynamic> image;
  String name;
  String description;
  String mrp;
  String wholesale;
  String price;
  String offer;
  String quantity;
  List<dynamic>quantities;
  bool stock;
  String seller;
  String delivery;
  String replace;
  String document;
  Product(
      this.tag,
      this.tags,
      this.image,
      this.name,
      this.description,
      this.mrp,
      this.wholesale,
      this.price,
      this.offer,
      this.quantity,
      this.quantities,
      this.stock,
      this.seller,
      this.delivery,
      this.replace,
      this.document);

  Product.fromDocumentSnapshot(DocumentSnapshot e){
//    Product()
  }
}

class CartData{
  String image;
  String name;
  String mrp;
  String wholesale;
  String price;
  String quantity;
  int count;
  String total;
  String seller;
  String sellerTotal;
  String product;
  CartData(this.image, this.name, this.mrp, this.wholesale, this.price, this.quantity,this.count,this.total,this.seller,this.sellerTotal,this.product);
}

class Restaurant{
  String seller;
  String image;
  String name;
  String description;
  int open;
  int close;
  String time;
  bool status;
  String fssai;
  Restaurant(this.seller,this.image, this.name, this.description, this.open, this.close,this.time,this.status, this.fssai);
}

class Items{
  String image;
  String name;
  String description;
  String price;
  String quantity;
  String item;
  String tag;
  Items(this.image, this.name, this.description, this.price, this.quantity,this.item,this.tag);
}

class ProfileDetails{
  static String region;
  static String profile;
  static String mail;
  static String location;
  static int pinCode;
  static int delivery;
  static String name;
  static String number;
  static List<dynamic> address;
  static List<CartData>cart=[];
  static bool load;

  static getRegion()async{
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    CollectionReference reference=Firestore.instance.collection('Users');
    reference.document(user.uid).get().then((value){
      mail=value.data['mail'];
      profile=value.data['profile'];
      region=value.data['region'];
      location=value.data['location'];
      pinCode=value.data['pincode'];
      delivery=value.data['delivery'];
      name=value.data['name'];
      number=value.data['number'];
      address=value.data['address'];
    }).catchError((onError){
      print(onError);
    });
  }

  static getCart()async{
    cart.clear();
    FirebaseUser user=await FirebaseAuth.instance.currentUser();
    CollectionReference reference=Firestore.instance.collection('Users').document(user.uid).collection('Cart');
    try{
      QuerySnapshot querySnapshot=await reference.getDocuments();
      querySnapshot.documents.map((e){
        cart.add(CartData(e.data['image'], e.data['name'], e.data['mrp'], e.data['wholesale'], e.data['price'],
            e.data['quantity'], e.data['count'], e.data['total'], e.data['seller'], e.data['sellerTotal'],e.documentID));
      }).toList();
      load=false;
    }catch(e){
      load=false;
      print(e.toString());
    }
  }
}


class Offer{
  String image;
  String name;
  String description;
  String amounttype;
  String type;
  String offer;
  String upto;
  String min;

  Offer(this.image, this.name, this.description, this.amounttype ,this.type, this.offer,
      this.upto,this.min);
}

class Seller{
  String name;
  String number;
  String address;
  String doc;
  Seller(this.name, this.number, this.address,this.doc);
}
class FoodCategory{
  String image;
  String name;
  FoodCategory(this.image, this.name);
}

class Order{
  String id;
  String upass;
  String spass;
  String offer;
  String offertype;
  String image;
  List<dynamic>seller;
  String total;
  String saving;
  String discount;
  String sub;
  String paid;
  int booking;
  String name;
  String address;
  String phone;
  String payment;
  String pstatus;
  String status;
  String doc;

  Order(
      this.id,
      this.upass,
      this.spass,
      this.offer,
      this.offertype,
      this.image,
      this.seller,
      this.total,
      this.saving,
      this.discount,
      this.sub,
      this.paid,
      this.booking,
      this.name,
      this.address,
      this.phone,
      this.payment,
      this.pstatus,
      this.status,this.doc);
}

class PaymentView{
  String id;
  String amount;
  String close;
  String type;
  int time;

  PaymentView(this.id, this.amount, this.close, this.type,this.time);

}

class OrderItems{
  String name;
  String image;
  String id;
  String price;
  String total;
  int pieces;
  String quantity;
  String seller;
  OrderItems(
      this.name, this.image, this.id, this.price, this.total, this.pieces,this.quantity,this.seller);
}


class ProductLoader{
  static final ProductLoader instance = ProductLoader._();
  ProductLoader._();

  Map<String,ValueNotifier<List<Product>>> catWiseProducts = {};

  syncCategory(String category,{bool force = false}){
    if(catWiseProducts[category]==null){
      catWiseProducts[category] = ValueNotifier<List<Product>>(null);
    }
    if(catWiseProducts[category].value==null || force){
      Firestore.instance.collection("Products").where("verify", isEqualTo: true).where("tag", isEqualTo: category).orderBy("name").limit(5).getDocuments().then((value){
        print(value.documents.length);
        catWiseProducts[category].value = value.documents.map((e)=>Product(
            e.data['tag'],
            e.data['tags'],
            e.data['image'],
            e.data['name'],
            e.data['description'],
            e.data['mrp'],
            e.data['wholesale'],
            e.data['price'],
            e.data['offer'],
            e.data['quantity'],
            e.data['quantities'],
            e.data['stock'],
            e.data['seller'],
            e.data['delivery'],
            e.data['replace'],
            e.documentID)).toList();
        catWiseProducts[category].notifyListeners();
      });
    }
  }

  bool loading = false;
  loadMore(String category){
    if(!loading && (catWiseProducts[category].value!=null)){
      loading = true;
      final lastProd = catWiseProducts[category].value.last;
      Firestore.instance.collection("Products").where("verify", isEqualTo: true).where("tag", isEqualTo: category).orderBy("name").startAfter([lastProd.name]).limit(15).getDocuments().then((value){
        catWiseProducts[category].value.addAll(value.documents.map((e)=>Product(
            e.data['tag'],
            e.data['tags'],
            e.data['image'],
            e.data['name'],
            e.data['description'],
            e.data['mrp'],
            e.data['wholesale'],
            e.data['price'],
            e.data['offer'],
            e.data['quantity'],
            e.data['quantities'],
            e.data['stock'],
            e.data['seller'],
            e.data['delivery'],
            e.data['replace'],
            e.documentID)).toList());
        catWiseProducts[category].notifyListeners();
        loading = false;
      });
    }
  }

}