import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prasad/config.dart';

class NearByNGO extends StatefulWidget {
  const NearByNGO({Key? key}) : super(key: key);

  @override
  _NearByNGOState createState() => _NearByNGOState();
}

class _NearByNGOState extends State<NearByNGO> {
  List<String> ngoNames = [
    "Akshara Centre",
    "ALERT-INDIA Association for Leprosy education, Rehabilitation & Treatment India",
    "Annamrita-ISKCON Food Relief Foundation",
    "Antarang Foundation",
    "Ashadeep Association",
    "Catalysts For Social Action",
    "Community Outreach Programme (CORP)",
    "Cuddles Foundation",
    "Dignity Foundation",
  ];

  List<String> ngoAddress = [
    'Neelambari 501, Road No 86, Off Gokhale Road, Dadar (W) Mumbai 400028 Maharashtra',
    "B-9, Mira Mansion, Sion West, Mumbai 400022 Maharashtra",
    "19, Jaywant Industrial Estate, 63 Tardeo Road, Mumbai 400034 Maharashtra",
    "231/C, Tawripada Compound, Dr Ss Rao Road, Lalbaug, Parel, Mumbai 400012 Maharashtra",
    "B/9-103, New Jaiphalwadi Sra Co-Op Housing Society Behind Police Quarters, Tardeo, Mumbai 400036 Maharashtra",
    "B002, Shakti Apartments, Cardinal Gracias Road, Chakala, Andheri (E), Mumbai 400099 Maharashtra",
    "Catalysts For Social Action (Csa) 711 & 712, Bhaveshvar Arcade Annex, Nityanand Nagar,Opposite Shreyas Cinema, Lbs Marg, Ghatkopar (W), Mumbai- 400086 Maharashtra. India",
    "Methodist Centre,1St Floor, 21, Ymca Road, Mumbai Central Mumbai 400008 Maharashtra",
    "C/O Nangia & Co. , 1101, 11Th Floor, Tower B, Peninsula Business Park, Ganpat Rao Kadam Marg, Lower Parel, Mumbai - 400013",
    "B 206, Byculla Services Industries Premises, Sussex Road, Byculla (East) Mumbai 400027 Maharashtra",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Near-by NGOs",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView.builder(
                itemCount: ngoNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    width: double.infinity,
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business_center,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 220,
                                  child: Text(
                                    ngoNames[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    ngoAddress[index],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })));
  }
}
