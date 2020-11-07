class IndiItem {
  List<dynamic> categories;
  String name, image, unit, uid;
  bool inStock, selected = false;
  int price, rank, tick, quantity;
  IndiItem(
      {this.categories,
      this.name,
      this.image,
      this.unit,
      this.inStock,
      this.price,
      this.rank,
      this.tick,
      this.uid});
}
