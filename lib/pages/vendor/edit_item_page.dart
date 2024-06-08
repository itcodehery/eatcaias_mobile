import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum IsVegEnum { veg, nonVeg }

enum IsInStock { inStock, outOfStock }

class EditItemPage extends StatefulWidget {
  const EditItemPage(
      {Key? key,
      required this.shopName,
      required this.itemName,
      required this.itemDescription,
      required this.itemPrice,
      required this.isVeg,
      required this.isInStock})
      : super(key: key);

  final String shopName;
  final String itemName;
  final String itemDescription;
  final int itemPrice;
  final bool isVeg;
  final bool isInStock;

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  //controllers
  final itemNameController = TextEditingController();
  final itemDescriptionController = TextEditingController();
  final itemPriceController = TextEditingController();

  //variables
  IsInStock _inStock = IsInStock.inStock;

  //keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    itemDescriptionController.text = widget.itemDescription;
    itemPriceController.text = widget.itemPrice.toString();
    _inStock = widget.isInStock ? IsInStock.inStock : IsInStock.outOfStock;
    super.initState();
  }

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
          title: const Text('Edit Item'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 90,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.itemName,
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                    isVegTag(widget.isVeg),
                  ],
                )),
              ),
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Item'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Delete Item?'),
                            content: const Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  try {
                                    supabase
                                        .from('menu_item')
                                        .delete()
                                        .eq('item_name', widget.itemName)
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(normalSnackBar(
                                              "${widget.itemName} has been deleted!"));
                                      Navigator.of(context).pop();
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
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ));
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.save),
          label: const Text('Save Changes'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                await supabase
                    .from('menu_item')
                    .update({
                      'description': itemDescriptionController.text,
                      'price': int.parse(itemPriceController.text),
                      'is_inStock':
                          _inStock == IsInStock.inStock ? true : false,
                    })
                    .eq(
                      'item_name',
                      widget.itemName,
                    )
                    .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(normalSnackBar(
                          "${widget.itemName} has been edited!"));

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
        ),
      ),
    );
  }
}
