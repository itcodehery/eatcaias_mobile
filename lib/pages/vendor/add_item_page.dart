import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';

enum IsVegEnum { veg, nonVeg }

enum IsInStock { inStock, outOfStock }

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

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
        body: Padding(
          padding: dialogPadding,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const ListTile(
                  title: Text('Item Details'),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ListTile(
                          title: TextFormField(
                            controller: itemNameController,
                            decoration: const InputDecoration(
                              labelText: 'Item Name',
                              hintText: 'Enter item name',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please enter item name";
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: itemDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Item Description',
                              hintText: 'Enter item description',
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please enter item description";
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: TextFormField(
                            controller: itemPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Item Price',
                              hintText: 'Enter item price',
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
                        ),
                      ],
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
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //save item
                Navigator.of(context).pop();
              }
            },
            label: const Text('Confirm')),
      ),
    );
  }
}
