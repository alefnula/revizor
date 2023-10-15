import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Revizor());
}

class Revizor extends StatelessWidget {
  const Revizor({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revizor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

@immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _classifier;
  String imageUrl = "https://via.placeholder.com/150"; // placeholder image URL
  String _text = "";
  final TextEditingController _searchController = TextEditingController();
  String _currentSearch = "";
  final FocusNode _documentFocusNode = FocusNode();

  final TextStyle defaultTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: "Roboto",
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _documentFocusNode,
      onKey: (RawKeyEvent event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          setState(() {
            _text = "Neki moj text koji je dugacak";
          });
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          setState(() {
            _text = "Neki moj drugi text koji nije dugacak.";
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Revizor"),
        ),
        body: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem(
                        value: "something",
                        child: Text("Test"),
                      ),
                      DropdownMenuItem(
                        value: "test",
                        child: Text("tcwewrwsest"),
                      ),
                    ],
                    value: _classifier ?? "something",
                    onChanged: (value) {
                      setState(() {
                        _classifier = value;
                      });
                      _documentFocusNode.requestFocus();
                    },
                  ),
                  Image.network(imageUrl)
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: "Search",
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (text) {
                        setState(() {
                          _currentSearch = text;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            child: _buildTextAreaWithHighlight(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Previous"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Next"),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  RichText _buildTextAreaWithHighlight() {
    if (_currentSearch.isEmpty) {
      return RichText(
        text: TextSpan(
          text: _text,
          style: defaultTextStyle,
        ),
      );
    } else {
      RegExp regExp = RegExp(_currentSearch, caseSensitive: false);
      List<TextSpan> spans = [];
      int start = 0;
      Iterable<RegExpMatch> matches = regExp.allMatches(_text);
      for (RegExpMatch match in matches) {
        spans.add(
          TextSpan(
            text: _text.substring(start, match.start),
            style: const TextStyle(color: Colors.black),
          ),
        );
        spans.add(
          TextSpan(
            text: match.group(0),
            style: const TextStyle(
              color: Colors.black,
              backgroundColor: Colors.yellow,
            ),
          ),
        );
        start = match.end;
      }
      spans.add(
        TextSpan(
          text: _text.substring(start),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      );
      return RichText(
        text: TextSpan(
          children: spans,
          style: defaultTextStyle,
        ),
      );
    }
  }
}
