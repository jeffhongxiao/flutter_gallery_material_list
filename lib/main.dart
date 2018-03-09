import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = new ThemeData(
      primaryColor: Colors.blueGrey,
    );

    return new MaterialApp(
      title: 'List Demo from Flutter Gallery',
      //theme: new ThemeData.dark(),
      theme: themeData,
      home: new ListDemo(),
    );
  }
}

enum _MaterialListType {
  /// A list tile that contains a single line of text.
  oneLine,

  /// A list tile that contains two lines of text.
  twoLine,
}

class ListDemo extends StatefulWidget {
  const ListDemo({Key key}) : super(key: key);

  @override
  _ListDemoState createState() => new _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  List<String> items = <String>['A', 'B', 'C', 'D', 'E'];
  _MaterialListType _itemType = _MaterialListType.twoLine;
  bool _showIcons = false;
  bool _reverseSort = false;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<Null> _bottomSheet;

  void changeItemType(_MaterialListType type) {
    setState(() {
      _itemType = type;
    });
    _bottomSheet?.setState(() {});
  }

  MergeSemantics _mergeSemanticsOf(String text, _MaterialListType listType) {
    //const Text t = const Text(text);
    const Text t = const Text('we want a variable here');
    return new MergeSemantics(
      child: new ListTile(
          dense: true,
          title: t,
          trailing: new Radio<_MaterialListType>(
            value: listType,
            groupValue: _itemType,
            onChanged: changeItemType,
          )),
    );
  }

  MergeSemantics _mergeSemanticsOfOneline(_MaterialListType listType) {
    const Text t = const Text('one line');
    return new MergeSemantics(
      child: new ListTile(
          dense: true,
          title: t,
          trailing: new Radio<_MaterialListType>(
            value: listType,
            groupValue: _itemType,
            onChanged: changeItemType,
          )),
    );
  }

  MergeSemantics _mergeSemanticsOfTwoline(_MaterialListType listType) {
    const Text t = const Text('Two-line');
    return new MergeSemantics(
      child: new ListTile(
          dense: true,
          title: t,
          trailing: new Radio<_MaterialListType>(
            value: listType,
            groupValue: _itemType,
            onChanged: changeItemType,
          )),
    );
  }

  MergeSemantics _mergeSemanticsOfShowIcon() {
    const Text t = const Text('Show icon');
    return new MergeSemantics(
      child: new ListTile(
        dense: true,
        title: t,
        trailing: new Checkbox(
          value: _showIcons,
          onChanged: (bool value) {
            setState(() {
              _showIcons = value;
            });
            _bottomSheet?.setState(() {});
          },
        ),
      ),
    );
  }

  void _showConfigurationSheet() {
    final PersistentBottomSheetController<Null> bottomSheet = scaffoldKey
        .currentState.showBottomSheet((BuildContext bottomSheetContext) {
      final msOneline = _mergeSemanticsOfOneline(_MaterialListType.oneLine);
      final msTwoline = _mergeSemanticsOfTwoline(_MaterialListType.twoLine);
      final msShowIcon = _mergeSemanticsOfShowIcon();

      return new Container(
        decoration: const BoxDecoration(
          border: const Border(top: const BorderSide(color: Colors.black26)),
        ),
        child: new ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            msOneline,
            msTwoline,
            msShowIcon,
          ],
        ),
      );
    });

    setState(() {
      _bottomSheet = bottomSheet;
    });

    _bottomSheet.closed.whenComplete(() {
      if (mounted) {
        setState(() {
          _bottomSheet = null;
        });
      }
    });
  }

  Widget buildListTile(BuildContext context, String item) {
    Widget secondary;
    if (_itemType == _MaterialListType.twoLine) {
      secondary = const Text('Additional item information.');
    }

    return new MergeSemantics(
      child: new ListTile(
        leading: null,
        title: new Text('This item represents $item.'),
        subtitle: secondary,
        trailing: _showIcons
            ? new Icon(Icons.info, color: Theme.of(context).disabledColor)
            : null,
      ),
    );
  }

  String _decideItemTypeText() {
    switch (_itemType) {
      case _MaterialListType.oneLine:
        return 'Single-line';
      case _MaterialListType.twoLine:
        return 'Two-line';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    String itemTypeText = _decideItemTypeText();

    Iterable<Widget> listTiles =
        items.map((String item) => buildListTile(context, item));

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Scrolling list\n$itemTypeText'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: 'Sort',
            onPressed: () {
              setState(() {
                _reverseSort = !_reverseSort;
                items.sort((String a, String b) =>
                    _reverseSort ? b.compareTo(a) : a.compareTo(b));
              });
            },
          ),
          new IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Show menu',
            onPressed: _bottomSheet == null ? _showConfigurationSheet : null,
          ),
        ],
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: listTiles.toList(),
        ),
      ),
    );
  }
}
