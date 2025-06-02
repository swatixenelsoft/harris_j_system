import 'package:flutter/material.dart';

class LeaveLogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> claims = [
    {"form": "#2948", "amount": "1800.00", "count": "03"},
    {"form": "#2949", "amount": "2000.00", "count": "05"},
    {"form": "#2950", "amount": "1000.00", "count": "02"},
    {"form": "#2850", "amount": "1000.00", "count": "01"},
  ];

   LeaveLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
    Column(
          children: [
            // Top Tabs
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Claim",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Get Copies",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Headers
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Total Work Hours",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Total Work Hours",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // List of Claims
            Expanded(
              child: ListView.builder(
                itemCount: claims.length,
                itemBuilder: (context, index) {
                  final item = claims[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFEDEDED)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (val) {}),
                            Expanded(
                              child: Text(
                                "Claim Form : ${item['form']}",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              "Amount : \$ ${item['amount']}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const SizedBox(width: 40),
                            Text(
                              "individual claims ( ${item['count']} )",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Icon(Icons.remove_red_eye_outlined,
                                size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            Icon(Icons.download_rounded,
                                size: 18, color: Colors.red),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Submit Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );

  }
}
