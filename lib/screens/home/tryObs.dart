import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightScreen extends StatelessWidget {
  // Defining an observable directly in the widget
  var flightCount = 0.obs;
  var ss = {}.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) {
                      return ss.value.values.elementAt(i);
                    },
                    itemCount: ss.value.length,
                  )),
            ),
            // Using Obx to listen to changes in the observable
            Obx(() => Text(
                  'Flight Count: ${flightCount.value}',
                  style: TextStyle(fontSize: 20),
                )),
            ElevatedButton(
              onPressed: () {
                // Updating the observable directly
                flightCount.value++;
                ss.value.addAll({
                  flightCount.value: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  )
                });
              },
              child: Text('Increase Flight Count'),
            ),
          ],
        ),
      ),
    );
  }
}
