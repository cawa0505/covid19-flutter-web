import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:covid19/data/network/constants/endpoints.dart';
import 'package:covid19/icons/covid19_icons.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/custom_alert_dialog.dart';

/// [PreventionMobileScreen] Displays the information in regards to prevention of Coronavirus
/// and reference to where the data is taken from
/// Supports Mobile Screen Sizes
class PreventionMobileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Scaffold(
      // To make sure that the top of the body is aligned with top
      // of the AppBar and we do not have any unwanted background colors
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          screenHeight / 20,
        ),
        child: AppBar(
          // Leading set to empty container to remove the back button
          leading: Container(),
          // Setting the background color to transparent so that the
          // image can be full screen without any froeground colors
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          actions: <Widget>[
            // Adding padding to the action info button so it doesn't stick
            // to the side of the screen
            Padding(
              padding: EdgeInsets.only(
                right: screenWidth / 50,
              ),
              child: GestureDetector(
                // Displaying the dialog to reference the source of the
                // image
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                      title: RichText(
                        softWrap: true,
                        text: TextSpan(children: <TextSpan>[
                          // Dialog Title - Data Source
                          TextSpan(
                            text: '${Strings.dataSource}\n\n',
                            style: TextStyles.hightlightText.copyWith(
                              fontSize: screenHeight / 50,
                            ),
                          ),

                          // Dialog description referncing and linking the blog post
                          // and the Author
                          TextSpan(
                            style: TextStyles.statisticsSubHeadingTextStlye
                                .copyWith(
                              fontSize: screenHeight / 60,
                            ),
                            children: <InlineSpan>[
                              const TextSpan(
                                text: Strings.informationSourceDescription,
                              ),
                              TextSpan(
                                text: Strings.blog,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.accentBlueColor,
                                ),
                                // Launching the URL of the blog post
                                // throwing an error if the user doesn't have any browswer to open the link (Shouldn't ever happen)
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async => await canLaunch(
                                          Endpoints
                                              .preventionDataSourceReferenceURL)
                                      ? launch(Endpoints
                                          .preventionDataSourceReferenceURL)
                                      : throw 'Could not launch Refernce URL',
                              ),
                              const TextSpan(
                                text: Strings.writtenBy,
                              ),
                              // Launching the URL of the Author's Website
                              // throwing an error if the user doesn't have any browswer to open the link (Shouldn't ever happen)
                              TextSpan(
                                text: Strings.authorPrevetnionGraphic,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.accentBlueColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async => await canLaunch(
                                          Endpoints
                                              .preventionDataSourceAuthorURL)
                                      ? launch(Endpoints
                                          .preventionDataSourceAuthorURL)
                                      : throw 'Could not launch Refernce URL',
                              ),
                            ],
                          ),
                        ]),
                      ),

                      // Defining the Action item [Close] for the Dialog
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 25,
                              vertical: screenHeight / 75,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(-2, 4),
                                  blurRadius: 2,
                                  color: AppColors.boxShadowColor,
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(screenHeight / 75),
                              ),
                              color: AppColors.accentBlueColor,
                            ),
                            child: Text(
                              'Close',
                              style: TextStyles.statisticsHeadingTextStlye
                                  .copyWith(
                                fontSize: screenHeight / 65,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                // Adding the information Icon to the [AppBar]
                child: Icon(
                  Covid19Icons.error,
                  size: screenHeight / 25,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),

      // Prevention Image for COVID-19
      body: ScrollConfiguration(
        behavior: const CustomScrollBehaviour(),
        child: SingleChildScrollView(
          // Padding been added to keep the VISME logo visible at the bottom
          child: Container(
            padding: const EdgeInsets.only(
              top: Dimens.verticalPadding / 0.2,
              bottom: Dimens.verticalPadding / 0.15,
            ),
            color: AppColors.preventionBackgroundColor,
            child: Image.network(
              Endpoints.fetchPreventionGraphic,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: screenHeight,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(100, 105, 105, 105)),
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      // Back button to lead back to the [HomeScreen]
      // Floating Action Button used so that the item remains fixed when the image is scolled
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: screenHeight / 75,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: AppColors.blackColor,
          isExtended: true,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          icon: Icon(
            Covid19Icons.keyboardArrowLeft,
            size: screenHeight / 45,
            color: AppColors.offBlackColor,
          ),
          label: const Text(
            'Go Back',
            style: TextStyles.infoLabelTextStyle,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
