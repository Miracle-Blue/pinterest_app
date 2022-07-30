import 'package:flutter/material.dart';
import 'package:pinterest_app/core/constants.dart';

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.52,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
              ),
              const Text('Share to'),
            ],
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shareIcons.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  width: 70,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              index == 3 ? Colors.white : Colors.grey.shade200,
                          child: Image.asset(
                            shareIcons.keys.toList()[index],
                            height: (index != 5 && index != 6) ? 60 : 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        shareIcons.values.toList()[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Download image',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Hide Pin',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Report Pin\n'),
                  TextSpan(
                    text: "This goes against Pinterest's community guidelines",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'This Pin is inspired by your recent activity',
              style: TextStyle(),
            ),
          )
        ],
      ),
    );
  }
}
