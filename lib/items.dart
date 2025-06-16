// items_page.dart (assuming this is the file name)
import 'package:flutter/material.dart';
import 'item.dart'; // Import the Item model

class ItemsPage extends StatefulWidget {
  final List<Item> items; // List to hold items

  ItemsPage({Key? key, required this.items}) : super(key: key);

  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final _formKey = GlobalKey<FormState>();
  String itemName = '';
  String itemCategory = ''; // Changed from itemDescription
  String itemPrice = '';
  String itemImageUrl = '';
  String searchQuery = '';
  String sortOption = 'Name'; // Default sort option

  void addItem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.items.add(Item(
          name: itemName,
          category: itemCategory, // Changed from description
          price: double.tryParse(itemPrice) ?? 0.0,
          imageUrl: itemImageUrl,
        ));
        // Clear the input fields
        itemName = '';
        itemCategory = ''; // Changed from itemDescription
        itemPrice = '';
        itemImageUrl = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully!')),
      );
    }
  }

  void editItem(int index) {
    itemName = widget.items[index].name;
    itemCategory = widget.items[index].category; // Changed from description
    itemPrice = widget.items[index].price.toString();
    itemImageUrl = widget.items[index].imageUrl;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: itemName,
                  decoration: InputDecoration(labelText: 'Item Name'),
                  onChanged: (value) {
                    itemName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: itemCategory, // Changed from itemDescription
                  decoration: InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    itemCategory = value; // Changed from itemDescription
                  },
                ),
                TextFormField(
                  initialValue: itemPrice,
                  decoration: InputDecoration(labelText: 'Item Price'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    itemPrice = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: itemImageUrl,
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) {
                    itemImageUrl = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter image URL';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    widget.items[index] = Item(
                      name: itemName,
                      category: itemCategory, // Changed from description
                      price: double.tryParse(itemPrice) ?? 0.0,
                      imageUrl: itemImageUrl,
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Item updated successfully!')),
                  );
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.items.removeAt(index);
                });
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item deleted successfully!')),
                );
              },
              child: Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showItemDetails(Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Image.network(item.imageUrl),
                SizedBox(height: 10),
                Text('Price: ₹${item.price.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                Text('Category: ${item.category}'), // Changed from Description
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on the search query
    final filteredItems = widget.items.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // Sort items based on the selected sort option
    if (sortOption == 'Name') {
      filteredItems.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortOption == 'Price') {
      filteredItems.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == 'Category') {
      filteredItems.sort((a, b) => a.category.compareTo(b.category));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        actions: [
          DropdownButton<String>(
            value: sortOption,
            icon: Icon(Icons.sort),
            onChanged: (String? newValue) {
              setState(() {
                sortOption = newValue!;
              });
            },
            items: <String>['Name', 'Price', 'Category']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update the search query
                });
              },
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Item Name'),
                    onChanged: (value) {
                      itemName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Category'), // Changed from Description
                    onChanged: (value) {
                      itemCategory = value; // Changed from itemDescription
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Item Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      itemPrice = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Image URL'),
                    onChanged: (value) {
                      itemImageUrl = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter image URL';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: addItem,
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(filteredItems[index].name),
                      subtitle: Text(
                        'Price: ₹${filteredItems[index].price}\nCategory: ${filteredItems[index].category}', // Changed from Description
                      ),
                      leading: Image.network(
                        filteredItems[index].imageUrl,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => editItem(widget.items.indexOf(filteredItems[index])),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteItem(widget.items.indexOf(filteredItems[index])),
                          ),
                        ],
                      ),
                      onTap: () => showItemDetails(filteredItems[index]), // Show details on tap
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}