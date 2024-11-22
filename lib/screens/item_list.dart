import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/item.dart';
import 'item_form.dart';
import 'item_details.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late Future<List<Item>> items;

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  void refreshItems() {
    setState(() {
      items = AppDatabase.instance.fetchItems();
    });
  }

  void deleteItem(int id) async {
    await AppDatabase.instance.deleteItem(id);
    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Items'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Item>>(
        future: items,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No items found.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      item.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category: ${item.category}", style: TextStyle(fontSize: 14)),
                        Text("Price: \$${item.price}", style: TextStyle(fontSize: 14)),
                        Text("Quantity: ${item.quantity}", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteItem(item.id!);
                          },
                        ),
                        Icon(Icons.arrow_forward, color: Colors.teal),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemDetails(item: item)),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ItemForm()),
          ).then((_) => refreshItems()); // Atualiza a lista após adicionar
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
