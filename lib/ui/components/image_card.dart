import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String? image;
  final String status;

  const ImageCard({super.key, required this.image, required this.status});

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Stack(
            children: [
              Card(
                color: Colors.grey[300],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'No Pic',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Label box
              Positioned(
                top: 4,
                left: 20,
                right: 20,
                child: Container(
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 174, 197),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        // Card(
        //     color: Colors.grey[300],
        //     elevation: 2.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0),
        //     ),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: <Widget>[
        //         Container(
        //             width: double.infinity,
        //             padding: const EdgeInsets.symmetric(
        //                 horizontal: 10.0, vertical: 5.0),
        //             decoration: const BoxDecoration(
        //               color: Color.fromARGB(255, 255, 174, 197),
        //               borderRadius: BorderRadius.only(
        //                 topLeft: Radius.circular(10.0),
        //                 topRight: Radius.circular(10.0),
        //               ),
        //             ),
        //             child: const Center(
        //               child: Text(
        //                 '已回家',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 12,
        //                   // fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             )),
        //         const SizedBox(
        //           height: 6,
        //         ),
        //         const Center(
        //           child: Text(
        //             'No Pic',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
        : ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            child: Image.asset(
              image!,
              fit: BoxFit.cover,
            ),
          );
  }
}
