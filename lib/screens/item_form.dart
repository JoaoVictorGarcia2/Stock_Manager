import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/item.dart';

class ItemForm extends StatefulWidget {
  final Item? item; // Parâmetro opcional para edição de item

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

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // Preenche os campos com os valores do item para edição
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description ?? '';
      _categoryController.text = widget.item!.category ?? '';
      _priceController.text = widget.item!.price.toString();
      _quantityController.text = widget.item!.quantity.toString();
      _supplierController.text = widget.item!.supplier ?? '';
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        final double price = double.parse(_priceController.text);
        final int quantity = int.parse(_quantityController.text);

        // Cria ou atualiza o item
        final newItem = Item(
          id: widget.item?.id, // Mantém o ID se for edição
          name: _nameController.text,
          description: _descriptionController.text,
          category: _categoryController.text,
          price: price,
          quantity: quantity,
          supplier: _supplierController.text,
        );

        if (widget.item == null) {
          // Insere um novo item
          await AppDatabase.instance.insertItem(newItem);
        } else {
          // Atualiza o item existente
          await AppDatabase.instance.updateItem(newItem);
        }

        Navigator.pop(context); // Volta para a tela anterior
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
        title: Text(widget.item == null ? 'Novo Cadastro' : 'Editar Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'O campo Nome é obrigatório' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Categoria'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'O campo Preço é obrigatório';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um valor numérico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'O campo Quantidade é obrigatório';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Insira um número inteiro válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _supplierController,
                decoration: InputDecoration(labelText: 'Fornecedor'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: Text(widget.item == null ? 'Salvar' : 'Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
