import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/item.dart';

class ItemForm extends StatefulWidget {
  final Item? item; 

  const ItemForm({Key? key, this.item}) : super(key: key);

  @override
  _ItemFormState createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _supplierController = TextEditingController();
  Item? itemToEdit;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      itemToEdit = widget.item;
      _nameController.text = itemToEdit!.name;
      _descriptionController.text = itemToEdit!.description;
      _categoryController.text = itemToEdit!.category;
      _priceController.text = itemToEdit!.price.toString();
      _quantityController.text = itemToEdit!.quantity.toString();
      _supplierController.text = itemToEdit!.supplier;
    }
  }

  void _saveOrUpdateItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        final double price = double.parse(_priceController.text);
        final int quantity = int.parse(_quantityController.text);

        final updatedItem = Item(
          id: itemToEdit?.id ?? 0,  
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          price: price,
          quantity: quantity,
          supplier: _supplierController.text,
        );

        if (itemToEdit != null) {
          await AppDatabase.instance.updateItem(updatedItem);
        } else {
          await AppDatabase.instance.insertItem(updatedItem);
        }

        Navigator.pop(context);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Por favor, insira valores válidos para Preço e Quantidade.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemToEdit == null ? 'Novo Cadastro' : 'Editar Item'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Nome', 'O campo Nome é obrigatório'),
              _buildTextField(_descriptionController, 'Descrição', null),
              _buildTextField(_categoryController, 'Categoria', null),
              _buildTextField(
                _priceController,
                'Preço',
                'O campo Preço é obrigatório',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'O campo Preço é obrigatório';
                  if (double.tryParse(value) == null) return 'Insira um valor numérico válido';
                  return null;
                },
              ),
              _buildTextField(
                _quantityController,
                'Quantidade',
                'O campo Quantidade é obrigatório',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'O campo Quantidade é obrigatório';
                  if (int.tryParse(value) == null) return 'Insira um número inteiro válido';
                  return null;
                },
              ),
              _buildTextField(_supplierController, 'Fornecedor', null),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveOrUpdateItem,
                child: Text(itemToEdit == null ? 'Salvar' : 'Atualizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, 
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String? validationMessage, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        keyboardType: keyboardType,
        validator: validator ??
            (validationMessage != null
                ? (value) => value!.isEmpty ? validationMessage : null
                : null),
      ),
    );
  }
}
