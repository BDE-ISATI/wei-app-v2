import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/utils/colors.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: colorPrimary,
          primaryVariant: colorPrimaryVariant,
          onPrimary: colorWhite,
          secondary: colorSecondary,
          secondaryVariant: colorSecondaryVariant,
          onSecondary: colorWhite,
          background: colorScaffolddWhite,
          onBackground: colorBlack,
          error: colorError,
          onError: colorWhite,
          surface: colorScaffolddWhite,
          onSurface: colorBlack
        ),

        scaffoldBackgroundColor: colorScaffolddWhite,
        dividerColor: const Color(0xffefefef),

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 48, color: colorBlack),
          headline2: TextStyle(fontSize: 40, color: colorBlack),
          headline3: TextStyle(fontSize: 32, color: colorBlack),
          headline4: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: colorBlack),
          headline5: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: colorBlack),
          headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorBlack),
          bodyText2: TextStyle(fontSize: 16),
          button: TextStyle(fontSize: 16)
        ),

        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: colorScaffolddWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: colorBlack),
          titleTextStyle: TextStyle(color: colorBlack, fontSize: 40)
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xffedf1f7),
          thickness: 1
        ),

        visualDensity: VisualDensity.standard, 
      ),
      home: SafeArea(child: MyHomePage(title: 'ISATI Integration')),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SelectableText(
              'You have pushed the button this many times:',
            ),
            SelectableText(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
