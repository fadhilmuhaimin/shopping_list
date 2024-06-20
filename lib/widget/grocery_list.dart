// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';
import 'package:http/http.dart' as http;
class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  String? _error;
  var _isLoading = true;

  @override
  void initState() {
    _loadItems();
    super.initState();
  }
  void _loadItems() async {
    final url = Uri.https(
        'shopping-list-d5e12-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list.json');
    try{
      final response = await http.get(url);
      if(response.statusCode >= 400){
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if(response.body == 'null'){
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String,dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries){
        final category = categories.entries.firstWhere((catItem) => catItem.value.name == item.value['category']).value;
        loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category));
      }

      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });
    }catch(error){
      setState(() {
        _error = 'Something went wrong! Please try again later.';
      });
    }
  }

  void _addItem() async {
    final newItem =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (context) => NewItem(),
    ));
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });

  }

  void _removeItem(GroceryItem item) async{
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https('shopping-list-d5e12-default-rtdb.asia-southeast1.firebasedatabase.app',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No Items added yet"),);

    if(_isLoading){
      content = const Center(child: CircularProgressIndicator(),);
    }


    
    if (_groceryItems.isNotEmpty){
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, idx) {
            return Dismissible(
              onDismissed: (direction){
                _removeItem(_groceryItems[idx]);
              },
              key: ValueKey(_groceryItems[idx].id),
              child: ListTile(
                title: Text(_groceryItems[idx].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[idx].category.color,
                ),
                trailing: Text(_groceryItems[idx].quantity.toString()),
              ),
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
          });
    }

    if (_error != null){
      content = Center(child: Text(_error!),);
    }
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
      body: content
    );
  }
}
