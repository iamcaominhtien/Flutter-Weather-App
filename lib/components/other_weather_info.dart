import 'package:flutter/material.dart';
import '../services/networking.dart';

class OtherWidgetInformation extends StatefulWidget {
  final dynamic data;
  const OtherWidgetInformation({Key? key, this.data}) : super(key: key);

  @override
  State<OtherWidgetInformation> createState() => _OtherWidgetInformationState();
}

class _OtherWidgetInformationState extends State<OtherWidgetInformation> {
  @override
  Widget build(BuildContext context) {
    var data = CurrentOneCallOpenWeather(data: widget.data['current']);

    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Row(
            children: [
              OtherWidgetInformationCard(
                bodyIcon: 'gauge',
                value: data.pressure(),
                metric: 'hPA',
                title: 'Áp suất khí quyển',
                titleIcon: 'at_press',
              ),
              const SizedBox(
                width: 30,
              ),
              OtherWidgetInformationCard(
                title: 'Bình minh',
                titleIcon: 'sunrise',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.sunRise(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/sunrise2.png',
                        width: 60,
                      ),
                    ),
                    Text('Hoàng hôn: ${data.sunSet()}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 150,
          child: Row(
            children: [
              OtherWidgetInformationCard(
                value: data.uvi(),
                title: 'Mức UVI',
                bodyIcon: 'uvi_white_black_2',
                titleIcon: 'uv_white_black',
              ),
              const SizedBox(
                width: 30,
              ),
              OtherWidgetInformationCard(
                value: data.clouds(),
                metric: '%',
                title: 'Mây phủ',
                bodyIcon: 'cloud_icon',
                titleIcon: 'partly-cloudy',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

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
                Text(widget.title!),
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
