import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:painter/painter.dart';

class IsPainter extends StatefulWidget {
  const IsPainter({Key? key, required this.title, required this.controller})
      : super(key: key);

  final String title;
  final PainterController controller;

  @override
  _IsPainter createState() => _IsPainter();
}

class _IsPainter extends State<IsPainter> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      IconButton(
          icon: const Icon(
            Icons.undo,
          ),
          tooltip: 'Undo',
          onPressed: () {
            if (widget.controller.isEmpty) {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      const Text('Aucun retour en arrière'));
            } else {
              widget.controller.undo();
            }
          }),
      IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: widget.controller.clear),
          IconButton(icon: const Icon(Icons.check), onPressed: () {
            Navigator.of(context).pop(widget.controller.finish());
          })
    ];
    return ClipRect(
        child: Navigator(
            onGenerateRoute: (route) => MaterialPageRoute<void>(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.grey,
                        title: Text(widget.title),
                        actions: actions,
                        bottom: PreferredSize(
                          preferredSize:
                              Size(MediaQuery.of(context).size.width, 30.0),
                          child: DrawBar(widget.controller),
                        )),
                    body: Center(
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Painter(widget.controller))),
                  ),
                )));
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  const DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          );
        })),
        ColorPickerButton(
          _controller,
          background: false,
        ),
        ColorPickerButton(
          _controller,
          background: true,
        ),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool background;

  const ColorPickerButton(this._controller, {required this.background});

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_iconData, color: _color),
        tooltip: widget.background
            ? 'Modifier la couleur de fond'
            : 'Modifier la couleur de dessin',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Choisissez'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget.background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget.background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget.background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
