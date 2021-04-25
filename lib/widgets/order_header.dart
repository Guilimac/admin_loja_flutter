import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_admin/blocs/user_bloc.dart';

class OrderHeader extends StatelessWidget {

  final DocumentSnapshot order;


  OrderHeader(this.order);

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final user = userBloc.getUser(order.data["clientId"]);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${user["name"]}"),
            Text("${user["address"]}")
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Produtos R\$ ${order.data["productsPrice"].toStringAsFixed(2)}", style:  TextStyle(fontWeight: FontWeight.w500),),
            Text("Total: R\$ ${order.data["totalPrice"].toStringAsFixed(2)}", style:  TextStyle(fontWeight: FontWeight.w500),)
          ],
        )
      ],
    );
  }
}
