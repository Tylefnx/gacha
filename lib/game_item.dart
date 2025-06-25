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
      header: map['header'],
      bottom: map['bottom'].toString(),
      name: map['name'],
      image: map['image'],
      imageFile: map['imageFile'],
      description: map['description'],
    );
  }
}

List<GameItem> getMockGameItems() {
  GameItem item1 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item2 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item3 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item4 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );

  GameItem item5 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item6 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item7 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item8 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );

  GameItem item9 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );

  GameItem item10 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item11 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  GameItem item12 = GameItem(
    id: '1',
    quantity: 10,
    bgColor: 0xFF6A0DAD,
    header: 'Epic Item',
    bottom: 'Epic',
    name: 'Card',
    image: 'assets/card.png',
    imageFile: 'card.png',
    description: 'A powerful card with epic abilities.',
    type: 1,
    limit: 5,
    price: 100,
  );
  return [
    item1,
    item2,
    item3,
    item4,
    item5,
    item6,
    item7,
    item8,
    item9,
    item10,
    item11,
    item12,
  ];
}
