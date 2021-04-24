import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();

  Stream<List> get ouUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};
  Firestore _firestore = Firestore.instance;

  UserBloc() {
    _addUsersListener();
  }

  void onChangedSearch(String search){
    if(search.trim().isEmpty){
      _usersController.add(_users.values.toList());
    }else{
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search){
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());
    filteredUsers.retainWhere((user) {
      return user["name"].toUpperCase().contains(search.toUpperCase());
    });
    return filteredUsers;
    }

  void _addUsersListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;
        switch (change.type) {
          case DocumentChangeType.added:
            _users[uid] = change.document.data;
            _subscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            _unSubscribeToOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]["ubscription"] = _firestore.collection("users").document(uid)
        .collection("orders").snapshots().listen((orders) async {
      int numOrders = orders.documents.length;
      double money = 0.0;
      for (DocumentSnapshot d in orders.documents) {
        DocumentSnapshot order = await _firestore.collection("orders").document(
            d.documentID).get();

        if(order.data == null) continue;
        money += order.data["totalPrice"];
      }
      _users[uid].addAll({"money":money, "orders":numOrders});

      _usersController.add(_users.values.toList());
    });
  }

  void _unSubscribeToOrders(String uid){
    _users[uid]["ubscription"].cancel();
  }

  @override
  void dispose() {
    _usersController.close();
  }

}