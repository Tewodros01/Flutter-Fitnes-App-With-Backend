import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/models/get_book_info.dart';
import 'package:project/view/page/book/detail_book.dart';

class BookCategory extends StatelessWidget {
  final List<BookInfo>? book;
  String? category;
  BookCategory({super.key, this.book, this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              Text(
                category!,
                style: GoogleFonts.lato(
                  fontSize: 30,
                  color: Get.isDarkMode ? Colors.white : Colors.black38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              itemCount: book?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => DetailBookPage(bookInfo: book![index]));
                        },
                        child: book!.length == 0
                            ? CircularProgressIndicator()
                            : Container(
                                height: 160,
                                width: 141,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "http://10.0.2.2:8000/uploads/${book![index].book_thumbnail}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      book!.length == 0
                          ? CircularProgressIndicator()
                          : Text(
                              book![index].book_title!,
                              style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
