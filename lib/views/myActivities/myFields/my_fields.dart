import 'package:flutter/material.dart';
import 'package:takwira_app/views/cards/field_card.dart';
import 'package:takwira_app/views/fieldProfile/field_profile.dart';
import 'package:takwira_app/views/myActivities/myFields/all_my_fields.dart';
import 'package:takwira_app/views/navigation/fields.dart';

class MyFields extends StatelessWidget {
  final dynamic? fields, otherFields;
  const MyFields({super.key, this.fields, this.otherFields});

  @override
  Widget build(BuildContext context) {
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Column(
            children: List.generate(
              fields.length > 3 ? 3 : fields.length,
              (index) {
                final field = fields[index];
                return Column(
                  children: [
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FieldProfile(field: field),
                            ),
                          );
                        },
                        child: Ink(
                            child: Stack(
                          children: [
                            FieldCard(field: field),
                          ],
                        )),
                      ),
                    ),
                    SizedBox(height: width(20)),
                  ],
                );
              },
            ),
          ),
          if (fields.length != 0)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllMyFields(fields: fields),
                  ),
                );
              },
              child: Text(
                'See more',
                style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'See other fields',
                  style: TextStyle(
                    color: const Color(0xFFF1EED0),
                    fontSize: width(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Fields(),
                        ),
                      );
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                          color: const Color(0xFFF1EED0),
                          fontSize: width(10),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: width(10)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    otherFields.length,
                    (index) {
                      final field = otherFields[index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FieldProfile(field: field),
                                ),
                              );
                            },
                            child: Ink(child: FieldCard(field: field)),
                          ),
                          SizedBox(width: width(11)),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: width(25)),
        ],
      ),
    );
  }
}
