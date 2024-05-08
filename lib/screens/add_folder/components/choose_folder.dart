import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FolderAdded extends StatelessWidget {
  const FolderAdded({
    Key? key,
    required this.title,
    required this.image,
    required this.words,
    required this.press,
    required this.name,
    required this.sets,
    required this.isLarge,
    required this.isSelected,
  }) : super(key: key);

  final bool isLarge;
  final bool isSelected;
  final String title, image, name;
  final int words, sets;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    double widthBox = MediaQuery.of(context).size.width;
    double small = widthBox - 100;
    double large = widthBox - 50;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: isLarge ? large : small,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.yellow : Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_outlined, color: Colors.grey, size: 30),
                      SizedBox(width: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: [
                        Text(
                          '$sets set',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: CachedNetworkImageProvider(image),
                        ),
                        SizedBox(width: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 73, 73, 73),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
