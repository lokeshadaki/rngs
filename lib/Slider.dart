import 'package:rngs/LoginScreen.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    "assets/img/3.gif",
    "assets/img/1.png",
    "assets/img/2.gif",
  ];

  void _goToNextPage() {
    if (_currentPage < _images.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skip() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _pageController.jumpToPage(entry.key),
                  child: Container(
                    width: 7.0,
                    height: 7.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == entry.key
                          ? Colors.black87
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            child: TextButton(
              onPressed: _skip,
              child: Text(
                'Skip',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: ElevatedButton(
              onPressed: _goToNextPage,
              child: Text(
                _currentPage == _images.length - 1 ? 'Finish' : 'Next',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87, // Background color
                foregroundColor: Colors.white, // Text color
            ),
          ),
          )
        ],
      ),
    );
  }
}


