import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';
import 'package:hey_voltz/widgets/button.dart';

Material buildBottomSheetForDirection(
  double deviceWidth, {
  required var station,
}) {
  return Material(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
    elevation: 10,
    child: Container(
      width: deviceWidth,
      padding: const EdgeInsets.all(15),
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorAccentTwo,
                      image: DecorationImage(
                          image: NetworkImage(station['image']))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        station['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        station['address'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      // const Text(
                      //   '_state, _country',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 10,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(svgDistance),
                    Text(
                      '${station['distance']} km',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Material buildBottomSheet(double deviceWidth,
    {required var station,
    required Function() onDirectionsTap,
    required Function() onAddToFavorite}) {
  return Material(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
    elevation: 10,
    child: Container(
      width: deviceWidth,
      padding: const EdgeInsets.all(15),
      height: 325,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 75,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorAccentTwo,
                      image: DecorationImage(
                          image: NetworkImage(station['image']))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        station['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        station['address'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      // const Text(
                      //   '_state, _country',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 10,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onAddToFavorite,
                  icon: const Icon(
                    Icons.star_rounded,
                    size: 25,
                  ),
                  splashRadius: 25,
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(svgDistance),
                    Text(
                      '${station['distance']} km',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Row(
          //   children: [
          //     const Text(
          //       'Open: 6am - 11pm',
          //       style: TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     const Spacer(),
          //     IconButton(
          //         onPressed: () {},
          //         splashRadius: 20,
          //         icon: const Icon(
          //           Icons.star_rounded,
          //           color: colorAccent,
          //         ))
          //   ],
          // ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildCard(
                  ss: SvgPicture.asset(
                    svgChargerType,
                    height: 25,
                  ),
                  label: station['charger'],
                ),
              ),
              Container(
                height: 25,
                width: 2,
                color: colorAccentTwo,
              ),
              Expanded(
                child: buildCard(
                    ss: Text(
                      station['speed'].toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    label: 'Speed'),
              ),
              Container(
                height: 25,
                width: 2,
                color: colorAccentTwo,
              ),
              Expanded(
                child: buildCard(
                    ss: Text(
                      station['fee'].split('/')[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    label: 'per kW'),
              ),
            ],
          ),
          const Spacer(),
          ButtonPrimary(label: 'Directions', onTap: onDirectionsTap),
        ],
      ),
    ),
  );
}

Column buildCard({var ss, required String label}) {
  return Column(
    children: [
      ss,
      const SizedBox(height: 5),
      Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    ],
  );
}
