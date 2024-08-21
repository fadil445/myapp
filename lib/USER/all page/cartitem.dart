class CartItem {
  final String image;
  final String title;
  final int price;
  int quantity;

  CartItem({
    required this.image,
    required this.title,
    required this.price,
    this.quantity = 1,
  });
}
