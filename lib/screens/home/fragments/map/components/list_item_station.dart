import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';

class StationListItem extends StatefulWidget {
  StationListItem(
      {Key? key,
      this.imageUrl,
      required this.name,
      required this.address,
      required this.state,
      required this.country,
      required this.distance})
      : super(key: key);

  String? imageUrl;
  String name;
  String address;
  String state;
  String country;
  String distance;

  @override
  _StationListItemState createState() => _StationListItemState();
}

class _StationListItemState extends State<StationListItem> {
  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 90,
            color: colorPrimary,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.address,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              // Text(
              //   '${widget.state}, ${widget.country}',
              //   style: const TextStyle(
              //     fontSize: 11,
              //   ),
              // ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(svgDistance),
              const SizedBox(height: 5),
              Text(
                '${widget.distance} km',
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
    );
  }
}
