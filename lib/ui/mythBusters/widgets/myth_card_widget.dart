import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/res/asset_images.dart';
import 'package:covid19/ui/mythBusters/widgets/myth_fact_item_widget.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';

/// To Build the widget to display the card for each Myth/Fact
///
/// **Requires**
/// 1. [myth] - To display the myth on the Cards on the [MythBustersScreen]
/// 2. [fact] - To display the fact on click of the card
class MythCardWidget extends StatelessWidget {
  final String myth, fact;

  const MythCardWidget({
    Key key,
    @required this.myth,
    @required this.fact,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Column(
      children: <Widget>[
        GestureDetector(
          // Opening [Dialog] with the fact on click of each Myth
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    // Placing the background inside an [IgnorePointer so that feedback isn't accepted]
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: AppColors.offBlackColor.withOpacity(0.5),
                      ),
                    ),
                    // Using Animated padding to add the animation of the dialog appearing in
                    // to the screen
                    AnimatedPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: screenHeight / 10,
                      ),
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      child: Container(
                        // Defining the width to be taken by the children as the entire width of the screen
                        width: screenWidth,
                        // using a column to lay out the icon and the Fact Item
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Fact Icon
                            Container(
                              width: screenWidth / 8,
                              height: screenWidth / 8,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 29,
                                    color: AppColors.boxShadowColor,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(screenWidth / 10),
                                ),
                                color: AppColors.factColor,
                              ),
                              child: Center(
                                child: Image.asset(
                                  AssetImages.fact,
                                  height: screenWidth / 8,
                                ),
                              ),
                            ),

                            // Vertical Spacing
                            SizedBoxHeightWidget(screenHeight / 10),

                            // Displaying the Fact item
                            MythFactItemWidget(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              shadowColor: AppColors.factColor,
                              text: fact,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },

          // Adding the Myth Item with a spacing b/w each item using [SizedBoxHeightWidget]
          child: MythFactItemWidget(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            shadowColor: AppColors.mythColor,
            text: myth,
          ),
        ),

        // Vertical Spacing
        SizedBoxHeightWidget(screenHeight / 75),
      ],
    );
  }
}
