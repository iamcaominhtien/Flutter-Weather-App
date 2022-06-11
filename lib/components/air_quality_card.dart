import 'package:flutter/material.dart';

class AirQualityCard extends StatefulWidget {
  const AirQualityCard({Key? key, this.data, required this.daily})
      : super(key: key);
  final dynamic data;
  final bool daily;

  @override
  State<AirQualityCard> createState() => _AirQualityCardState();
}

class _AirQualityCardState extends State<AirQualityCard> {
  @override
  Widget build(BuildContext context) {
    // var data = CurrentWeatherData(data: widget.data);
    var data = widget.data;
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          children: [
            WidgetItem(
              label: 'Tốc độ gió',
              img: 'windspeed',
              data: data.windSpeed + "m/s",
            ),
            WidgetItem(
              label: 'Độ ẩm',
              img: 'humidity',
              data: data.humidity + "%",
            ),
            widget.daily == false
                ? WidgetItem(
                    label: 'Tầm nhìn xa',
                    img: 'eye',
                    data: data.humidity + "km",
                  )
                : WidgetItem(
                    label: 'Mức UV',
                    img: 'uv',
                    data: data.uvi,
                  ),
          ],
        ));
  }
}

class WidgetItem extends StatefulWidget {
  final String data, img, label;
  const WidgetItem(
      {Key? key, required this.data, required this.img, required this.label})
      : super(key: key);

  @override
  State<WidgetItem> createState() => _WidgetItemState();
}

class _WidgetItemState extends State<WidgetItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(widget.label),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Color(0xffE0E8FB),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Image.asset('assets/${widget.img}.png'),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.data,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
