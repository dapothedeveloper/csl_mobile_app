import 'package:cewers_flutter/custom_widgets/button.dart';
import 'package:cewers_flutter/custom_widgets/cewer_title.dart';
import 'package:cewers_flutter/custom_widgets/main-container.dart';
import 'package:flutter/material.dart';

class ReportNotification extends StatelessWidget {
  final String report;
  final String location;
  ReportNotification(this.report, this.location, {Key key}) : super(key: key);
  Widget build(BuildContext context) {
    return MainContainer(
        decoration: null,
        displayAppBar: CewerAppBar("Alert ", "Recieved!"),
        child: Container(
          child: Column(children: [
            Card(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 24),
                child: Column(
                  children: <Widget>[
                    SafeArea(
                      minimum: EdgeInsets.only(top: 20, bottom: 25),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Report Details",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          )),
                    ),
                    Align(
                      heightFactor: 2,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Location: ",
                          ),
                          Text(location),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(report),
                    ),
                    Align(
                      heightFactor: 2,
                      alignment: Alignment.bottomRight,
                      child: ActionButtonBar(
                        text: "VIEW ALERT STATUS",
                        action: () {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Viewing Alert Status",
                                style: Theme.of(context).textTheme.headline,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}

// {
// 	"alert":{
// 		"userId":"5e9ea7e2337e4322391c758b",
// 		"alertType":"crime",
// 		"location":"6.4623144,3.4778092",
// 		"priority": "medium",
// 		"comment": "testing2",
// 		"pictures": ["picture1.png", "picture2.png"],
// 		"videos": ["video1.png", "video2.png"]
// 	}
// }
