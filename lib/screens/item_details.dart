import 'package:flutter/material.dart';
import '../models/item.dart';
import 'item_form.dart'; // Tela para editar o item

class ItemDetails extends StatelessWidget {
  final Item item;

  const ItemDetails({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ),
                Divider(thickness: 2, height: 30),
                Text(
                  "Category: ${item.category}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  "Price: \$${item.price}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  "Quantity: ${item.quantity}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  "Description: ${item.description}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Navegar para a tela de formulário com os dados preenchidos para edição
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemForm(item: item), // Passe o item atual
                        ),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      "Edit Item",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
