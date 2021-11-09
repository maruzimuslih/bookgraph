import 'package:bookgraph/login_page.dart';
import 'package:bookgraph/model/books.dart';
import 'package:bookgraph/model/daily_goals.dart';
import 'package:bookgraph/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> animation;
  DateTime today = DateTime.now();
  double dailyGoal = 30;
  double currentProgress = 17;

  List<charts.Series<Goals, DateTime>> seriesLineData = [
    charts.Series(
      colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.cyan[700]!),
      id: 'Daily Goals',
      data: weeklyProgress,
      domainFn: (Goals goals, _) => goals.date,
      measureFn: (Goals goals, _) => goals.pages,
    )
  ];

  @override
    void initState() {
      super.initState();
      progressController = AnimationController(vsync: this, duration: Duration(seconds: 1));
      animation = Tween<double>(begin: 0, end: currentProgress)
        .animate(progressController)
        ..addListener(() => setState(() {}));
      progressController.forward();      
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('${widget.user.avatar}'),
          ),
        ),
        centerTitle: true,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "Book",
              style: TextStyle(color: Colors.white, fontSize: 16)
            ),
            TextSpan(
              text: "Graph",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)
            )
          ])
        ),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => LoginPage()),
              ModalRoute.withName('/')
            );
          }          
        )],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // ------------------- Greeting ----------------------  //
            Container(
              padding: EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.cyan[900],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome back,',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                    ),
                  ),
                  Text('${widget.user.nickName}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),
            // ------------------- Greeting (end) ----------------------  //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------- Currently Reading ----------------------  //
                Container(
                  padding: EdgeInsets.only(left: 20, top: 120),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Currently ",
                        style:
                          TextStyle(color: Colors.white, fontSize: 20)
                      ),
                      TextSpan(
                        text: "Reading",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ])
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  height: 125,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20, bottom: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: bookList.length,
                    itemBuilder: (context, index){
                      return CurrentlyReadingList(book: bookList[index]);
                    }
                  ),
                ),
                // ------------------- Currently Reading (end) ----------------------  //
                // ------------------- Daily Reading Goal ----------------------  //
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Daily ",
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20)
                      ),
                      TextSpan(
                        text: "Reading ",
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20)
                      ),
                      TextSpan(
                        text: "Goal",
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20, fontWeight: FontWeight.bold)
                      )
                    ])
                  ),
                ),
                SizedBox(height: 15),
                // ------------------- Today Data ----------------------  //
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),                  
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      color: Colors.cyan[900]!.withOpacity(.3)
                    )]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '${currentProgress.toInt()}',
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
                                    ),
                                    TextSpan(
                                      text: ' pages',
                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                    ),
                                  ])
                                ),
                                Text(
                                  'Still need ${(dailyGoal - currentProgress).toInt()} pages to reach the goal',
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            CustomPaint(
                              foregroundPainter: CircleProgress(animation.value, dailyGoal),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/book.svg',
                                    color: Colors.cyan[900],
                                    width: 26
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ------------------- Today Data (end) ----------------------  //
                      SizedBox(height: 10),
                      // ------------------- Daily Data ----------------------  //
                      Container(
                        height: 160,
                        width: MediaQuery.of(context).size.width,
                        child: charts.TimeSeriesChart(
                          seriesLineData,
                          animate: true,
                          animationDuration: Duration(seconds: 1),
                          behaviors: [
                            charts.SlidingViewport(),
                            charts.ChartTitle('Date',
                              titleStyleSpec: charts.TextStyleSpec(fontSize: 10),
                              behaviorPosition: charts.BehaviorPosition.bottom,
                              titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                            ),
                            charts.ChartTitle('Pages',
                              titleStyleSpec: charts.TextStyleSpec(fontSize: 10),
                              behaviorPosition: charts.BehaviorPosition.start,
                              titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                            ),
                          ],
                          primaryMeasureAxis: charts.NumericAxisSpec(
                            renderSpec: charts.GridlineRendererSpec(                                    
                              labelStyle: charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.black),
                            ),
                            tickProviderSpec: charts.StaticNumericTickProviderSpec(<charts.TickSpec<num>>[
                                charts.TickSpec<num>(0),
                                charts.TickSpec<num>(10),
                                charts.TickSpec<num>(20),
                                charts.TickSpec<num>(30),
                              ],
                            ),
                          ),
                          domainAxis: charts.DateTimeAxisSpec(
                            renderSpec: charts.SmallTickRendererSpec(
                              minimumPaddingBetweenLabelsPx: 0,
                              labelStyle: charts.TextStyleSpec(fontSize: 10, color: charts.MaterialPalette.black),
                              lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.black)
                            ),
                            viewport: charts.DateTimeExtents(
                              start: today.subtract(Duration(days: 7)),
                              end: today,
                            ),
                            tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
                            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                              day: charts.TimeFormatterSpec(
                                format: 'dd/MM',
                                transitionFormat: 'dd/MM',
                              ),
                            ),
                            showAxisLine: false,
                          ),
                        ),
                      )
                      // ------------------- Daily Data (end) ----------------------  //
                    ],
                  ),
                ),
                // ------------------- Daily Reading Goal (end) ----------------------  //
                SizedBox(height: 30),
                // ------------------- Reading Challenge ----------------------  //
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${today.year} ',
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20)
                      ),
                      TextSpan(
                        text: 'Reading ',
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20)
                      ),
                      TextSpan(
                        text: 'Challenge',
                        style: TextStyle(color: Colors.cyan[900], fontSize: 20, fontWeight: FontWeight.bold)
                      )
                    ])
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 20,
                      color: Colors.cyan[900]!.withOpacity(.3)
                    )
                  ]),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5, right: 30, top: 5, bottom: 5),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Image.asset('assets/images/reading-challenge.png', width: 100),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '$completedBooks',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' books completed',
                                      style: TextStyle(
                                        color: Colors.black, 
                                        fontSize: 14
                                      ),
                                    ),
                                  ])
                                ),
                                Text(
                                  "You're on track!",
                                  style: TextStyle(
                                    color: Colors.grey, fontSize: 12
                                  ),
                                ),
                                SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: LinearProgressIndicator(                                      
                                    value: completedBooks.toDouble() / yearGoal,
                                    minHeight: 12,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[900]!),
                                    backgroundColor: Colors.cyan[700],
                                  ),
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '$completedBooks/$yearGoal ($yearProgressInPercent%)',
                                    style: TextStyle(fontSize: 12)
                                  ),
                                ),
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  )
                )
                // ------------------- Reading Challenge (end) ----------------------  //
              ],
            )
          ]
        )
      ),
    );
  }
}

class CurrentlyReadingList extends StatelessWidget {
  final Book book;

  CurrentlyReadingList({required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(     
      margin: EdgeInsets.only(right: 20), 
      width: 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(
          offset: Offset(0, 10),
          blurRadius: 20,
          color: Colors.cyan[900]!.withOpacity(.3)
        )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Text(
                        book.author,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Page ${book.currentPage} of ${book.totalPage}",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ),
                Image.asset(book.imageAsset, width: 70)
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            child: LinearProgressIndicator(
              value: book.currentPage / book.totalPage,
              minHeight: 6,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan[900]!),
              backgroundColor: Colors.cyan[700],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleProgress extends CustomPainter{

  double currentProgress, goal;

  CircleProgress(this.currentProgress, this.goal);

  @override
  void paint(Canvas canvas, Size size) {    
    Paint outerCircle = Paint()
        ..strokeWidth = 8
        ..color = Colors.grey
        ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 8
      ..color = Colors.cyan[700]!
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 2;

    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (currentProgress/goal);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {    
    return true;
  }
}