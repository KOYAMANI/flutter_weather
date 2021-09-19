import 'package:flutter/material.dart';
import 'package:flutter_challenge/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_challenge/domain/models/models.dart';
import 'package:flutter_challenge/domain/repositories/repositories.dart';
import 'package:flutter_challenge/helpers/helpers.dart';

//This is a widget to show detailed forcast based on the current user location

class WeatherForecast extends StatefulWidget {
  final UserLocation userLocation;
  const WeatherForecast({Key? key, required this.userLocation})
      : super(key: key);

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  TimeHelper timeHelper = TimeHelper();
  WeatherIconHelper weatherIconHelper = WeatherIconHelper();

  BoxDecoration customDecoration = const BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment(0.5, -1.1),
        end: Alignment(1.0, 1.0),
        colors: [Colors.blueAccent, Colors.lightBlueAccent]),
  );

  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();
  @override
  void initState() {
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: customDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ListTile(
                  trailing: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              child: Consumer(builder: (context, watch, child) {
                final weather = watch(weatherProvider(widget.userLocation));
                return weather.when(
                  data: (weather) => Column(
                    children: [
                      Text(
                        widget.userLocation.city,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        '${weather[0].temp2m}°C',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Expanded(
                        child: ListView.builder(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: weather.length,
                            itemBuilder: (context, index) {
                              final data = weather[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Show weekday
                                    // Text(
                                    //     timeHelper
                                    //         .getDayAndTime(id: data.timepoint)
                                    //         .weekday,
                                    //     style: Theme.of(context)
                                    //         .textTheme
                                    //         .bodyText1),
                                    // Show time in 24hour
                                    // first data should be the data for now
                                    if (index == 0)
                                      Text('Now',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    if (index != 0)
                                      Text(
                                          timeHelper
                                              .getDayAndTime(id: data.timepoint)
                                              .hour
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),

                                    Icon(weatherIconHelper.getWeatherIcon(
                                        data: data)),
                                    Text(
                                      '${data.temp2m}°C',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                  error: (error, _) => Column(
                    children: [
                      Text(error.toString()),
                      ElevatedButton(
                        onPressed: () {
                          context.refresh(weatherProvider(widget.userLocation));
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: Consumer(builder: (context, watch, child) {
                final weather = watch(weatherProvider(widget.userLocation));
                return weather.when(
                  data: (weather) => Column(
                    children: [
                      const Divider(
                          color: Colors.white,
                          height: 8,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('day',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('time',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('cloud',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('seeing',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('transp',
                                style: Theme.of(context).textTheme.bodyText1),
                            Text('wind',
                                style: Theme.of(context).textTheme.bodyText1),
                            // Text('lifted Idx',
                            //     style: Theme.of(context).textTheme.bodyText2),
                            Text('humid',
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ),
                      const Divider(
                          color: Colors.white,
                          height: 8,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5),
                      Expanded(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          child: ListView.builder(
                              controller: _verticalScrollController,
                              itemCount: 9,
                              itemBuilder: (context, index) {
                                final data = weather[index];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      8.0, 12.0, 8.0, 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      //TODO need to consider which data to show
                                      // Show weekday
                                      Text(
                                          timeHelper
                                              .getDayAndTime(id: data.timepoint)
                                              .weekday,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      const SizedBox(width: 7),
                                      if (index == 0)
                                        Text('Now',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      if (index != 0)
                                        Text(
                                            timeHelper
                                                .getDayAndTime(
                                                    id: data.timepoint)
                                                .hour
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      const SizedBox(width: 7),
                                      Text(cloudCover['${data.cloudcover}']!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      const SizedBox(width: 7),
                                      Text(seeing['${data.seeing}']!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      const SizedBox(width: 7),
                                      Text(
                                          transparency['${data.transparency}']!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      const SizedBox(width: 7),
                                      Text('${data.windData.speed}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                      // const SizedBox(width: 7),
                                      // Text(liftedIndex['${data.liftedIndex}']!,
                                      //     style: Theme.of(context)
                                      //         .textTheme
                                      //         .bodyText1),
                                      const SizedBox(width: 7),
                                      Text(
                                        rh2m['${data.rh2m}']!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      const SizedBox(width: 7),
                                      // Text('precType: ${data.precType}'),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                    ),
                  ),
                  error: (error, _) => Column(
                    children: [
                      Text(error.toString()),
                      ElevatedButton(
                        onPressed: () {
                          context.refresh(weatherProvider(widget.userLocation));
                        },
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}