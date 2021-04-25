import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_header.dart';

class OrderTile extends StatelessWidget {
  final DocumentSnapshot order;

  OrderTile(this.order);

  final states = [
    "",
    "Em Preparação",
    "Em transporte",
    "Aguardando Entrega",
    "Entregue"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data["status"] != 4,
          title: Text(
            "${order.documentID.substring(order.documentID.length - 7, order.documentID.length)} - "
            "${states[order.data["status"]]}",
            style: TextStyle(
              color: order.data["status"] != 4 ? Colors.grey : Colors.green,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                      order.data['products'].map<Widget>((p) {
                        return ListTile(
                          title: Text(p["product"]["title"] + " " + p["size"]),
                          subtitle: Text(p["category"]),
                          trailing: Text(
                            p["quantity"].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Firestore.instance.collection("users").document(order["clientId"])
                            .collection("orders").document(order.documentID).delete();
                            order.reference.delete();
                          },
                          textColor: Colors.red,
                          child: Text("Excluir")),
                      FlatButton(
                          onPressed: order.data["status"] > 1 ? () {
                            order.reference.updateData({"status": order.data["status"] -1});
                          } : null,
                          textColor: Colors.grey[850],
                          child: Text("Regredir")),
                      FlatButton(
                          onPressed:order.data["status"] < 4 ? () {
                            order.reference.updateData({"status": order.data["status"] +1});
                          } : null,
                          textColor: Colors.green,
                          child: Text("Avançar"))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
