import 'package:flutter/material.dart';

import '../../../utils/lang/colors.dart';
import 'avatar_with_initials.dart';

class PerangkatSayaCard extends StatelessWidget {
  final Color color;
  final String title;
  final bool isActive;
  final String role;
  final String category;
  final String deviceID;
  final String dueDate;
  final String devicePkey;
  final String devicePhoneNumber;
  final bool isInbox;

  const PerangkatSayaCard({
    super.key,
    required this.color,
    required this.title,
    required this.role,
    required this.isActive,
    required this.category,
    required this.deviceID,
    required this.dueDate,
    required this.devicePkey,
    required this.devicePhoneNumber,
    required this.isInbox,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12, // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 6, // Blur radius
            offset: const Offset(0, 3), // Offset for the shadow (x, y)
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 0.0, right: 0.0),
                child: Row(
                  children: [
                    Container(
                      width: 50.0, // Width of the circle
                      height: 50.0, // Height of the circle
                      decoration: const BoxDecoration(
                        color: AppColors.primary, // Background color (green)
                        shape: BoxShape.circle, // Circular shape
                      ),
                      child: Center(
                        child: AvatarWithInitials(
                          fullName: (deviceID.isEmpty || double.tryParse(deviceID) != null) ? 'Anonymous' : deviceID,
                          imageUrl: null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Device ID",
                          style: TextStyle(
                            color: AppColors.primary, // Lighter blue text color
                            fontSize: 12,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deviceID,
                              style: TextStyle(
                                color: Colors.black54, // White text for the main count
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              devicePkey,
                              style: TextStyle(
                                color: Colors.black54, // White text for the main count
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        color: AppColors.primary, // Lighter blue text color
                        fontSize: 12,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role,
                            style: TextStyle(
                              color: Colors.black54, // White text for the main count
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            devicePhoneNumber,
                            style: TextStyle(
                              color: Colors.black54, // White text for the main count
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inbox / Due at",
                      style: TextStyle(
                        color: AppColors.primary, // Lighter blue text color
                        fontSize: 12,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            color: Colors.black54, // White text for the main count
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          dueDate,
                          style: TextStyle(
                            color: Colors.black54, // White text for the main count
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(
            thickness: 0.5,
            color: AppColors.primary,
            indent: 0,
            endIndent: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 12.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 1), borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'FREE / 200',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the row takes only the needed space
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.redAccent.shade700,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8), // Spacing between the circle and text
                      Text(
                        isActive ? "CONNECTED" : "DISCONNECTED",
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.redAccent.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
