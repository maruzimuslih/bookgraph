class Book{
  String title;
  String author;
  String imageAsset;
  int totalPage;
  int currentPage;

  Book({
    required this.title,
    required this.author,
    required this.imageAsset,
    required this.totalPage,
    required this.currentPage,
  });
}

var bookList = [
  Book(
    title: 'Crushing & Influence',
    author: 'Gary Venchuk',
    imageAsset: 'assets/images/book-1.png',
    totalPage: 243,
    currentPage: 17
  ),
  Book(
    title: 'Top Ten Business Hacks',
    author: 'Herman Joel',
    imageAsset: 'assets/images/book-2.png',
    totalPage: 153,
    currentPage: 46
  ),
  Book(
    title: 'How To Win Friends & Influence',
    author: 'Gary Venchuk',
    imageAsset: 'assets/images/book-3.png',
    totalPage: 172,
    currentPage: 143
  ),
];

var completedBooks = 4;
var yearGoal = 21;
var yearProgress = completedBooks/yearGoal;
var yearProgressInPercent = (yearProgress * 100).toInt();