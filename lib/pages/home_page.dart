import 'package:contact_with_sqlite/helpers/database_helper.dart';
import 'package:contact_with_sqlite/models/contact.dart';
import 'package:contact_with_sqlite/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper db = DatabaseHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    //insertTemp();
    _showAllContacts();
  }

  void _showAllContacts(){ 
    db.getContacts().then((value){
      setState(() {
        contacts = value;
      });
    });
  }

  void insertTemp() {
    Contact c1 = Contact(1, 'Maria', 'maria@gmail.com', 'teste.jpg');
    db.insertContact(c1);
    Contact c2 = Contact(2, 'Pedro', 'pedro@gmail.com', 'teste2.jpg');
    db.insertContact(c2);

    db.getContacts().then((value) => print(value));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 0,
        itemBuilder: (context, index) {
          return _listContacts(context, index);
        },
      ),
    );
  } 
  Widget _listContacts(BuildContext context, index){
          return GestureDetector(
            onTap: () => _showContactPage(contact: contacts[index]),
            child: Card(
              child: Padding(
                padding:const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: contacts[index].image.isNotEmpty
                          ? FileImage(File(contacts[index].image))
                          : const AssetImage('image/user.png') as ImageProvider,
                          ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contacts[index].name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        contacts[index].email,
                        style: const TextStyle(fontSize: 15),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _confirmDeletion(context, contacts[index].id, index);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showContactPage({Contact? contact}) async{
      final contactReceived = await Navigator.push(context, 
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));
      if (contactReceived !=null){
        if(contact !=null){
          await db.updateContact(contactReceived);
        }else{
          await db.insertContact(contactReceived);
        }

        _showAllContacts();
      }
    }
  void _confirmDeletion(BuildContext context, int id, int index){
    showDialog(context: context, 
    builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Excluir Contato'),
        content: const Text('Confirme a exclusão do contato'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
            ),
          TextButton(
            onPressed: () {
              setState(() {
                contacts.removeAt(index);
                db.deleteContact(id);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Excluir'),
          ),
        ],
      );
    },
    );
  }
}
