import 'package:flutter/material.dart';
import 'package:todo/components/constants/constants.dart';
import 'package:todo/components/frontend/screen.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  PageController pc = PageController(initialPage: 0);
  int currentPage = 0;
  List<String> carouselImages = [
    "https://frombharat.com/storage/media/H8XelvJaB6Sonn4fG99vUQZhlSw0KqXjnsOmY04P.jpg",
    "https://frombharat.com/storage/media/o3JoXcGX9nIhRI47Gmbe9mblS0xxaE9rkLMadC1R.png",
    "https://frombharat.com/storage/media/T2Vc2PkiYSBff5CwBYzaMLCMBTrN0BYOsTZBaZsj.jpg"
  ];
  late List<Widget> screen;

  @override
  void initState() {
    screen = List.generate(
      3,
      (index) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: red.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Image.network(
                carouselImages[index],
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(12.5),
                child: const Text("Sample Text"),
              ),
            )
          ],
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Screen s = Screen(context);
    return Scaffold(
      backgroundColor: white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: s.width,
            height: 200,
            child: PageView(
              controller: pc,
              children: [...screen, const SizedBox.shrink()],
              onPageChanged: (value) {
                setState(() => currentPage = value);
                if (value == screen.length) {
                  pc.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            width: s.width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: screen.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: currentPage == index ? theme : grey,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
