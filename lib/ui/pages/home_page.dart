import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/ui/widgets/form.dart';
import 'package:palmmobilechalenge/ui/widgets/home_book_card.dart';
import 'package:palmmobilechalenge/shared/api_services.dart';
import 'package:palmmobilechalenge/model/book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Book>> futureBooks;
  String searchQuery = '';
  final ApiService _apiService = ApiService();
  int _selectedIndex = 0;

  Future<List<Book>> _loadBooks() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Jika tidak ada koneksi internet, langsung ambil dari local storage
      return _apiService.getBooksFromLocal();
    } else {
      // Jika ada koneksi internet, ambil dari API dan fallback ke local storage jika gagal
      return _apiService.fetchBooksWithFallback();
    }
  }

  @override
  void initState() {
    super.initState();
    futureBooks = _loadBooks();
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Book> filterBooks(List<Book> books) {
    if (searchQuery.isEmpty) {
      return books;
    } else {
      return books
          .where((book) =>
              book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              book.authors[0]['name']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Action for 'Home'
      Navigator.pushNamed(context, '/home-page');
    } else if (index == 1) {
      // Action for 'Likes'
      Navigator.pushNamed(context, '/likes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        elevation: 0,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: whiteColor,
          selectedItemColor: blueColor,
          unselectedItemColor: blackColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle:
              blueTextStyle.copyWith(fontSize: 10, fontWeight: medium),
          unselectedLabelStyle:
              blackTextStyle.copyWith(fontSize: 10, fontWeight: medium),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home.png',
                width: 20,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/social_network.png',
                width: 20,
              ),
              label: 'Likes',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 40,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
                color: whiteColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  CustomsFormField(
                    title: 'search',
                    onChanged: updateSearchQuery,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<Book>>(
                future: futureBooks,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Failed to load books: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No books found'));
                  } else {
                    final filteredBooks = filterBooks(snapshot.data!);
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return HomeBookCard(
                          title: book.title,
                          subtitle: book.authors[0]['name'],
                          imageUrl: book.formats['image/jpeg'] ?? '',
                          onTap: () {
                            Navigator.pushNamed(context, '/detail-book',
                                arguments: book);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
