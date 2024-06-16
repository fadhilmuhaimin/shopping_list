
// ignore_for_file: unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  final _fromKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuality = 1;
  var _selectedCategory = categories[Categories.vegetables];

  void _saveItem(){
    if(_fromKey.currentState!.validate()){
      _fromKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(id: DateTime.now().toString(), name: _enteredName, quantity: _enteredQuality, category: _selectedCategory!)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _fromKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _enteredName,
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName  = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _enteredQuality.toString(),
                      decoration: const InputDecoration(label: Text('Quantitiy')),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid, positive number';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _enteredQuality = int.parse(value!);
                      },
                    ),

                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      validator: (value) {
                        if(value == null){
                          return 'Harus Pilih Kategori';
                        }
                        return null;
                      },
                      items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                            child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: category.value.color,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(category.value.name)
                          ],
                        ))
                    ], onChanged: (value) {
                      setState(() {
                        _selectedCategory  = value;
                      });
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {
                    _fromKey.currentState!.reset();
                  }, child: const Text('Reset')),
                  ElevatedButton(onPressed: () {
                    _saveItem();
                  }, child: const Text('Add Item'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
