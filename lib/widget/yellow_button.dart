import 'package:flutter/widgets.dart';
import 'package:sleepaid/util/app_colors.dart';

class YellowButton extends StatefulWidget {
  String buttonText;
  final Function onTapCallback;
  int index;
  bool isSelected;

  YellowButton({
    required this.buttonText,
    required this.onTapCallback,
    required this.index,
    required this.isSelected,
  });

  @override
  State<StatefulWidget> createState() => _YellowButton();
}

class _YellowButton extends State<YellowButton> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onTapCallback(widget.index, isSelected);
        });
      },
      child: Container(
        width: 69,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.buttonYellow),
          borderRadius: BorderRadius.all(const Radius.circular(8)),
          color: isSelected ? AppColors.buttonYellow : AppColors.white,
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.buttonYellow,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}