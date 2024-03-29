import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurant_management_app/bin/models/product_model.dart';
import 'package:restaurant_management_app/bin/constants.dart';

import '../constants.dart';
import '../models/order_model.dart';
import '../entities/order_list.dart';

const double expandedMaxHeight = 400;

List<OrderModel> orders = OrderList.getOrderList();

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: ScrollController(),
        itemBuilder: (BuildContext context, int index) {
          return OrderSection(
            title: orders[index].tableId +
                '     ' +
                orders[index].price.toString(),
            orderModel: orders[index],
          );
        },
        itemCount: orders.length);
  }
}

//Order section/category widget
class OrderSection extends StatefulWidget {
  final String title;
  final OrderModel orderModel;

  const OrderSection({Key? key, required this.title, required this.orderModel})
      : super(key: key);

  @override
  _OrderSectionState createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Column(
        children: <Widget>[
          Container(
            // top bar containing title and expand button
            color: accent1Color,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                    // expand button
                    icon: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: const BoxDecoration(
                        color: mainColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          expandFlag
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
                Text(
                  // Section title
                  widget.title,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                )
              ],
            ),
          ),
          OrderSectionContent(
              // expanded content
              expanded: expandFlag,
              itemCount: widget.orderModel.products.length,
              child: ListView.builder(
                controller: ScrollController(),
                itemBuilder: (BuildContext context, int index) {
                  List<ProductModel> items = widget.orderModel.products;

                  return OrderItem(
                    price: items[index].price,
                    name: items[index].name,
                    quantity: widget.orderModel.quantities[index],
                    category: items[index].category,
                  );
                },
                itemCount: widget.orderModel.products.length,
              ))
        ],
      ),
    );
  }
}

class OrderSectionContent extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  late final double expandedHeight;
  final Widget child;
  final int itemCount;

  OrderSectionContent(
      {Key? key,
      required this.child,
      required this.itemCount,
      this.collapsedHeight = 0.0,
      this.expanded = true})
      : super(key: key) {
    expandedHeight = min(
        expandedMaxHeight, itemCount * 50); //50 is the height of a OrderItem
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      //expand animation
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
      ),
    );
  }
}

//Single item in a section's expanded tab
class OrderItem extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  late final double totalPrice;
  final String category;

  OrderItem({
    Key? key,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  }) : super(key: key) {
    totalPrice = price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: accent1Color),
          color: accent2Color),
      child: ListTile(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name + ' X' + quantity.toString()),
          Text(totalPrice.toString()),
        ]),
        leading: Icon(
          sectionIcons[category],
          color: mainColor,
        ),
      ),
    );
  }
}
