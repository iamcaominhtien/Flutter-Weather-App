import '../screens/loading_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sunny.jfif'),
            colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
            fit: BoxFit.fill,
          ),
          // color: Colors.black.withOpacity(1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/cloudy.png',
                width: 200,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Weather',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    'News & Feed',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: const TextSpan(
              //     style: TextStyle(
              //       fontWeight: FontWeight.w900,
              //       color: Colors.white,
              //       fontSize: 40,
              //     ),
              //     children: <TextSpan>[
              //       TextSpan(
              //         text: 'Weather',
              //         style: TextStyle(
              //           color: Colors.white,
              //         ),
              //       ),
              //       TextSpan(
              //         text: ' News & Feed',
              //         style: TextStyle(
              //           color: Colors.orange,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const Text(
                'Đưa ra các dự báo về thời tiết theo giờ và theo ngày',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide.none))),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoadingScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Bắt đầu',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
