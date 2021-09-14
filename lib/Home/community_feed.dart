import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prasad/config.dart';

class CommunityFeed extends StatefulWidget {
  const CommunityFeed({Key? key}) : super(key: key);

  @override
  _CommunityFeedState createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Community Feed",
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  //color: Colors.red,
                  height: 360,
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
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
                                  Text("Author Name")
                                ],
                              ),
                              Text("4 days ago",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey))
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 200,
                            width: double.infinity,
                            color: primaryColor,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                              height: 40,
                              child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
