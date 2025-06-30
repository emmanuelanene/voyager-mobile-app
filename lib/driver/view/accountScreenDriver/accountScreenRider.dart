import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:voyager/common/controller/provider/profileDataProvider.dart';
import 'package:voyager/common/controller/services/mobileAuthServices.dart';
import 'package:voyager/constant/utils/colors.dart';
import 'package:voyager/constant/utils/textStyles.dart';

class AccountScreenDriver extends StatefulWidget {
  const AccountScreenDriver({super.key});

  @override
  State<AccountScreenDriver> createState() => _AccountScreenDriverState();
}

class _AccountScreenDriverState extends State<AccountScreenDriver> {
  List accountTopButtons = [
    [CupertinoIcons.shield_fill, 'Help'],
    [CupertinoIcons.creditcard_fill, 'Payment'],
    [CupertinoIcons.square_list_fill, 'Activity'],
  ];


  List accountButtons = [
    [
      CupertinoIcons.gift_fill,
      'Send a gift',
    ],
    [
      CupertinoIcons.gear_alt_fill,
      'Settings',
    ],
    [
      CupertinoIcons.envelope_fill,
      'Messages',
    ],
    [
      CupertinoIcons.money_dollar_circle_fill,
      'Earn by driving or delivering',
    ],
    [
      CupertinoIcons.briefcase_fill,
      'Business hub',
    ],
    [
      CupertinoIcons.person_2_fill,
      'Refer friends, unlock deals',
    ],
    [
      CupertinoIcons.person_fill,
      'Manage Uber account',
    ],
    [
      CupertinoIcons.power,
      'Logout',
    ],
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProfileDataProvider>().getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          // Top Row
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            children: [
              //  Profile Data
              Consumer<ProfileDataProvider>(
                builder: (context, profileProvider, child) {
                  if (profileProvider.profileData == null) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            'User',
                            style: AppTextStyles.heading26Bold,
                          ),
                        ),
                        Container(
                          height: 16.w,
                          width: 16.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: black87,
                            ),
                            color: black,
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/uberLogo/uber.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            profileProvider.profileData!.name!,
                            style: AppTextStyles.heading26Bold,
                          ),
                        ),
                        Container(
                          height: 16.w,
                          width: 16.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: black87,
                            ),
                            color: black,
                            image: DecorationImage(
                                image: NetworkImage(profileProvider
                                    .profileData!.profilePicUrl!)),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),

              SizedBox(
                height: 3.h,
              ),
              // Top Row Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                /*
                accountTopButtons.map(...): Take each item in the list called accountTopButtons and transform it into something else (in this case, a widget).

                (e) => Container(...): For each item (named e), create a container widget. This container will hold the visual elements.

                Container(height: 10.h, width: 28.w, ...): Create a box with a fixed height and width, where 10.h means 10% of the screen height and 28.w means 28% of the screen width (using the Sizer package).

                BoxDecoration(color: greyShade3, borderRadius: BorderRadius.circular(8.sp)): Style the container by giving it a background color (greyShade3) and rounded corners with a radius of 8 scaled pixels (sp).

                child: Column(...): Inside the container, stack children vertically (one below the other).

                mainAxisAlignment: MainAxisAlignment.center: Align children vertically centered within the column.

                crossAxisAlignment: CrossAxisAlignment.center: Align children horizontally centered within the column.

                Icon(e[0], size: 4.h, color: black87): Show an icon using the first element of e (which is the icon data), with size set to 4% of screen height and color black87.

                SizedBox(height: 1.h): Add vertical spacing of 1% of screen height between the icon and the text.

                Text(e[1], style: AppTextStyles.small10): Show a text widget with the second element of e (the label) styled with a predefined small font style.

                .toList(): Convert the result of the map (which is an iterable) into a list of widgets that can be assigned to the children property.
                 */
                children: accountTopButtons
                    .map(
                      (e) => Container(
                        height: 10.h,
                        width: 28.w,
                        decoration: BoxDecoration(
                          color: greyShade3,
                          borderRadius: BorderRadius.circular(
                            8.sp,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              e[0],
                              size: 4.h,
                              color: black87,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              e[1],
                              style: AppTextStyles.small10,
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),

          Divider(
            color: greyShade2,
            thickness: 0.5.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accountButtons.length,
              itemBuilder: (context, index) {

                /*
                InkWell(...): A widget that detects taps and shows a ripple effect when tapped.

                onTap: () { ... }: This is the function that runs when the user taps the InkWell.

                if (index == (accountButtons.length - 1)) { MobileAuthServices.signOut(context); }: Check if the tapped item is the last one in the accountButtons list; if yes, call the signOut method to log the user out.

                child: Container(...): The visual content inside the InkWell, styled with padding.

                padding: EdgeInsets.symmetric(vertical: 2.h): Adds vertical padding (space) of 2% screen height above and below the container content.

                child: Row(...): Arrange children horizontally (side by side).

                children: [ Icon(...), SizedBox(...), Text(...) ]: Inside the row:
                    Icon(accountButtons[index][0], color: black, size: 3.h): Show the icon from the current accountButtons item, colored black, sized to 3% of screen height.

                    SizedBox(width: 7.w): Add horizontal space of 7% screen width between the icon and the text.

                    Text(accountButtons[index][1], style: AppTextStyles.small12): Show the text label from the current accountButtons item, styled with a small font style.
                 */
                return InkWell(
                  onTap: () {
                    if (index == (accountButtons.length - 1)) {
                      MobileAuthServices.signOut(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: Row(
                      children: [
                        Icon(
                          accountButtons[index][0],
                          color: black,
                          size: 3.h,
                        ),
                        SizedBox(
                          width: 7.w,
                        ),
                        Text(
                          accountButtons[index][1],
                          style: AppTextStyles.small12,
                        )
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    ));
  }
}
