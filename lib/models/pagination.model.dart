class Pagination {
  int previousPage;
  int currentPage;
  int itemsPerPages;
  int totalItems;

  Pagination(
      int previousPage, int currentPage, int itemsPerPages, int totalItems) {
    this.previousPage = previousPage;
    this.currentPage = currentPage;
    this.itemsPerPages = itemsPerPages;
    this.totalItems = totalItems;
  }

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(json['previousPage'], json['currentPage'],
        json['itemsPerPages'], json['totalItems']);
  }
}
