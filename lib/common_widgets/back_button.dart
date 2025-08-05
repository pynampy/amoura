import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const BackButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: onTap ?? () => Navigator.of(context).maybePop(),
          child: Container(
            margin: EdgeInsets.only(left: 10),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
