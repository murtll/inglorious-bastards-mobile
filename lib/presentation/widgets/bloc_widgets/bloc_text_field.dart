import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocTextField<B extends BlocBase<S>, S, R> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final Function(R? value) onChanged;
  final R? Function(String value) inputToValue;
  final B bloc;
  final R? Function(S state) stateValue;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? autocorrect;
  final int? maxLength;
  final bool? multiline;

  final FocusNode? focusNode;
  final bool obscureText;
  final bool enabled;
  final InputDecoration? decoration;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? cursorColor;
  final bool? autofocus;

  final bool? autocomplete;

  final TextStyle? style;

  final TextAlign? textAlign;

  const BlocTextField({
    Key? key,
    this.labelText,
    this.hintText,
    required this.onChanged,
    required this.bloc,
    required this.stateValue,
    required this.inputToValue,
    this.focusNode,
    this.obscureText = false,
    this.enabled = true,
    this.decoration,
    this.onFieldSubmitted,
    this.cursorColor,
    this.autofocus,
    this.autocomplete, this.inputFormatters, this.keyboardType, this.autocorrect, this.maxLength, this.multiline, this.style, this.textAlign,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocTextFieldState<B, S, R>();
}

class _BlocTextFieldState<B extends BlocBase<S>, S, R> extends State<BlocTextField<B, S, R>> {
  final _textController = TextEditingController();

  @override
  void initState() {
    final value = widget.stateValue(widget.bloc.state);
    _textController.value = _textController.value.copyWith(
      text: value?.toString() ?? '',
    );
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return BlocListener<B, S>(
      bloc: widget.bloc,
      listenWhen: (previous, current) {
        return widget.stateValue(previous) != widget.stateValue(current);
      },
      listener: (context, state) {
        final value = widget.stateValue(state);
        if (value != widget.inputToValue(_textController.text)) {
          _textController.value = _textController.value.copyWith(
            text: value?.toString() ?? '',
          );
        }
      },
      child: TextFormField(
        textAlign: widget.textAlign ?? TextAlign.center,
        style: widget.style,
        autofocus: widget.autofocus ?? false,
        maxLines: (widget.multiline ?? false) ? null : 1,
        maxLength: widget.maxLength,
        cursorColor: widget.cursorColor,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        decoration: widget.decoration ??
            InputDecoration(
              border: const OutlineInputBorder(),
              labelText: widget.labelText ?? '',
              hintText: widget.hintText ?? '',
            ),
        controller: _textController,
        onChanged: (value) {
          widget.onChanged(widget.inputToValue(value));
        },
        inputFormatters: widget.inputFormatters,
        autocorrect: widget.autocorrect ?? true,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
