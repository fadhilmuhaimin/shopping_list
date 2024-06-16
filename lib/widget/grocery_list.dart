// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem>_groceryItems =[];
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => NewItem(),
    ));
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, idx) {
            return ListTile(
              title: Text(_groceryItems[idx].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[idx].category.color,
              ),
              trailing: Text(_groceryItems[idx].quantity.toString()),
            );

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       ClipRRect(
            //         borderRadius: BorderRadius.circular(4.0),
            //         child: Container(
            //           color: groceryItems[index].category.color,
            //           height: 30,
            //           width: 30,
            //         ),
            //       ),
            //       SizedBox(width: 10,),
            //       Text(groceryItems[index].name.toString(), style: TextStyle(color: Colors.white),),
            //       Spacer(),
            //       Text(groceryItems[index].quantity.toString(), style: TextStyle(color: Colors.white),)
            //     ],
            //   ),
            // );
          }),
    );
  }
}
