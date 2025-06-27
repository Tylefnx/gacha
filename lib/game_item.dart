class GameItem {
  String? id;
  int? quantity;
  int? bgColor;
  String? header;
  String? bottom;
  String? name;
  String? image;
  String? imageFile;
  String? description;
  int? type;

  // to exchange
  int? limit;
  int? price;

  GameItem({
    this.id,
    this.quantity,
    this.bgColor,
    this.header,
    this.bottom,
    this.name,
    this.image,
    this.imageFile,
    this.description,
    this.type,
    this.limit,
    this.price,
  });

  factory GameItem.fromMap(Map<String, dynamic> map) {
    return GameItem(
      id: map['id'].toString(),
      quantity: int.tryParse(map['quantity'].toString()),
      bgColor: int.tryParse(map['bgColor'].toString()),
      type: int.tryParse(map['type'].toString()),
      limit: int.tryParse(map['limit'].toString()),
      price: int.tryParse(map['price'].toString()),
      header: map['header'].toString(),
      bottom: map['bottom'].toString(),
      name: map['name'].toString(),
      image: map['image'].toString(),
      imageFile: map['imageFile'].toString(),
      description: map['description'].toString(),
    );
  }
}
