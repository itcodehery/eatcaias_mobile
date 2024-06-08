import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum IsVegEnum { veg, nonVeg }

enum IsInStock { inStock, outOfStock }

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key, required this.shopName}) : super(key: key);

  final String shopName;

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  //controllers
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemPriceController = TextEditingController();

  //variables
  IsVegEnum _default = IsVegEnum.veg;
  IsInStock _inStock = IsInStock.inStock;

  //keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //build
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Discard Changes?'),
                  content:
                      const Text('Are you sure you want to discard changes?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Custom behavior here
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Discard Changes?'),
                        content: const Text(
                            'Are you sure you want to discard changes?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ));
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const ListTile(
                title: Text('Item Details'),
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: formPadding,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: itemNameController,
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            hintText: 'Enter item name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Please enter item name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: itemDescriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Item Description',
                            hintText: 'Enter item description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Please enter item description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: itemPriceController,
                          decoration: const InputDecoration(
                            labelText: 'Item Price',
                            hintText: 'Enter item price',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return "Please enter item price";
                            }
                            var intValue = int.tryParse(value);
                            if (intValue! < 10 || intValue > 1000) {
                              return "Please enter a valid number";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              const Divider(),
              const ListTile(
                title: Text('Item Type'),
              ),
              RadioListTile(
                value: IsVegEnum.veg,
                groupValue: _default,
                onChanged: (value) {
                  setState(() {
                    _default = IsVegEnum.veg;
                  });
                },
                title: const Text('Vegetarian'),
              ),
              RadioListTile(
                value: IsVegEnum.nonVeg,
                groupValue: _inStock,
                onChanged: (value) {
                  setState(() {
                    _default = IsVegEnum.nonVeg;
                  });
                },
                title: const Text('Non-Vegetarian'),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const ListTile(
                title: Text('Item Availability'),
              ),
              RadioListTile(
                value: IsInStock.inStock,
                groupValue: _inStock,
                onChanged: (value) {
                  setState(() {
                    _inStock = IsInStock.inStock;
                  });
                },
                title: const Text('In Stock'),
              ),
              RadioListTile(
                value: IsInStock.outOfStock,
                groupValue: _inStock,
                onChanged: (value) {
                  setState(() {
                    _inStock = IsInStock.outOfStock;
                  });
                },
                title: const Text('Out of Stock'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await supabase.from('menu_item').upsert([
                    {
                      'item_name': itemNameController.text,
                      'description': itemDescriptionController.text,
                      'price': itemPriceController.text,
                      'is_veg': _default == IsVegEnum.veg ? true : false,
                      'is_inStock':
                          _inStock == IsInStock.inStock ? true : false,
                      'shop_name': widget.shopName,
                    }
                  ]).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        normalSnackBar("Item has been added to database!"));
                    Navigator.of(context).pop();
                  });
                } on PostgrestException catch (e) {
                  Get.showSnackbar(GetSnackBar(
                    title: 'Retryable Error',
                    message: e.message,
                    backgroundColor: Colors.red,
                  ));
                } catch (error) {
                  Get.showSnackbar(GetSnackBar(
                    title: "Error",
                    message: error.toString(),
                    backgroundColor: Colors.red,
                  ));
                }
              }
            },
            label: const Text('Confirm')),
      ),
    );
  }
}
