import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class Card1 extends StatelessWidget {
  final doc;
  Card1(this.doc);
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration:const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                ),
                child: Image.network(doc['photoUrl']),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            // /margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                shape: BoxShape.circle),
                            height: 40,
                            width: 40,
                            child: ClipOval(
                              child: Image.network(
                                "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png",
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Text("${doc['authorName']}")
                        ],
                      ),
                      Text("4 days ago",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey))
                    ],
                  ),
                ),
                collapsed: Text(
                  '${doc['caption']}',
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      '${doc['caption']}',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    )),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
