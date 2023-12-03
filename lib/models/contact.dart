
class Contact {
  late int id;
  late String name;
  late String email;
  late String image;

    Contact(this.id, this.name, this.email, this.image);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id' : id,
      'name': name,
      'email' : email,
      'image' : image,
    };
    return map;
  }

  Contact.fromMap(Map<dynamic, dynamic> map){
    id = map['id'];
    name = map['name'];
    email = map['email'];
    image = map['image'];
  }
  
  @override 
  String toString(){
    return "Contact => (id: $id, name: $name, email: $email)";
  }
}
  