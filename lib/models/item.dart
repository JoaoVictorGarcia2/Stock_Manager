class Item {
  final int? id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int quantity;
  final String supplier;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
    required this.supplier,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'quantity': quantity,
      'supplier': supplier,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      quantity: map['quantity'],
      supplier: map['supplier'],
    );
  }
}
