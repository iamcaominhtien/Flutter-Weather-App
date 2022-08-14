import 'package:flutter/material.dart';

class OtherWidgetInformationCard extends StatefulWidget {
  const OtherWidgetInformationCard({
    Key? key,
    this.title,
    this.titleIcon,
    this.child,
    this.metric,
    this.value,
    this.bodyIcon,
  }) : super(key: key);

  final String? title;
  final String? titleIcon;
  final Widget? child;
  final String? metric;
  final String? value;
  final String? bodyIcon;

  @override
  State<OtherWidgetInformationCard> createState() =>
      _OtherWidgetInformationCardState();
}

class _OtherWidgetInformationCardState
    extends State<OtherWidgetInformationCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        // height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/${widget.titleIcon}.png',
                  width: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.title!,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 40,
            // ),
            widget.child ??
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Image.asset(
                      'assets/${widget.bodyIcon}.png',
                      width: 70,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        Text(
                          widget.value ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(widget.metric ?? ''),
                      ],
                    ),
                  ],
                )
          ],
        ),
      ),
    );
  }
}
