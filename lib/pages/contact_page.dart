import 'package:contact_with_sqlite/models/contact.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget{
  final Contact? contact;

  const ContactPage({super.key, this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameFocus = FocusNode();

  bool edited = false;
  Contact?  _editContact; 

  @override
  void initState(){
    super.initState();

    if(widget.contact == null) {
      _editContact = Contact(0, '', '', '');
    }else{
      _editContact = Contact.fromMap(widget.contact!.toMap());

      _nameController.text =  _editContact!.name;
      _emailController.text = _editContact!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          _editContact!.name == '' ? 'Novo Contato ' : _editContact!.name,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editContact!.name.isNotEmpty){
            Navigator.pop(context, _editContact);
          }else{
            _showWarning();
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child:Column(
          children: [
            GestureDetector(
              onTap: () {
              // ignore: invalid_user_of_visible_for_testing_member
              ImagePicker.platform
                  .getImageFromSource(source: ImageSource.gallery)
                  .then((file) {
                if (file == null) return;
                setState(() {
                _editContact!.image = file.path;
                });
              });
              },
              child: Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editContact!.image.isNotEmpty
                    ? FileImage(File(_editContact!.image))
                    : const AssetImage('images/user.png') as ImageProvider,
                  ),
                ),
                
              ),
          ),
          TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  onChanged: (value){
                    setState(() {
                      edited = true;
                      _editContact!.name = value;
                    });
                  },
                ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'E-mail' ),
            onChanged: (value){
              setState(() {
                edited = true;
                _editContact!.email = value;
              });
            },
            keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showWarning() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Nome'),
          content: const Text('informe o nome do contato'),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
} 