class Item {
  String name, imageUrl, uid;
  var categories;
  List<dynamic> varieties;
  Map displayNames;
  int rank;
  bool inStock;
  var searchArray;
  Item(
      {this.name,
      this.displayNames,
      this.imageUrl,
      this.rank,
      this.categories,
      this.searchArray,
      this.uid,
      this.varieties,
      this.inStock});
}
