import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';




class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(132, 131, 131, 0.39),
            Color.fromRGBO(54, 54, 54, 0.5)
          ]),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: const Color.fromRGBO(81, 73, 134, 0.89),
          ),
        ),
        child: ExpandableTheme(
          data: const ExpandableThemeData(
              iconPlacement: ExpandablePanelIconPlacement.right,
              iconColor: Colors.red,
              animationDuration: Duration(milliseconds: 500)),
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
                iconPlacement: ExpandablePanelIconPlacement.right),
            header: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "6 Months\nof Premium",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ 600",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            collapsed: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'you will be charged ₹600\nevery 6 Months ',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('6 months')
                ],
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'you will be charged ₹600\nevery 6 Months ',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('6 months')
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Details'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Monthly Subscription',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('₹ 600')
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Discount Voucher XYZ',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('- 0.0')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('₹ 600')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
