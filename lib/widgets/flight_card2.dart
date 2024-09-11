import 'package:flutter/material.dart';

import 'common.dart';

class FlightCard2 extends StatefulWidget {
  FlightCard2(
      {required this.data,
      required this.onLongPress,
      this.isBold = false,
      this.isSaved = false});
  final data;
  final Function? onLongPress;
  final bool isBold;
  bool isSaved;

  @override
  State<FlightCard2> createState() => _FlightCard2State();
}

class _FlightCard2State extends State<FlightCard2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            widget.onLongPress != null ? widget.onLongPress!() : null;
            widget.isSaved = widget.isSaved ? false : true;
            setState(() {});
          },
          onLongPress: () {
            widget.onLongPress != null ? widget.onLongPress!() : null;
            widget.isSaved = widget.isSaved ? false : true;
            setState(() {});
          },
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: widget.data['company_logo'] != null &&
                        widget.data['company_logo'] != ""
                    ? Image.network(
                        widget.data['company_logo'],
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const SizedBox();
                        },
                      )
                    : null,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text(
                      style: colorStyle(
                          isSmall: true,
                          isBold: true,
                          color: widget.isBold
                              ? Colors.yellowAccent
                              : Colors.white70),
                      "${widget.data?['flight_no'] ?? ""}")),
              Expanded(
                  child: Text(
                      style: colorStyle(
                          isSmall: true,
                          isBold: true,
                          color: widget.isBold
                              ? Colors.yellowAccent
                              : Colors.white70),
                      "${widget.data?["normal_time"] ?? ""}")),
              Expanded(
                  child: Text(
                      style: colorStyle(
                          isSmall: true,
                          isBold: true,
                          color: widget.isBold
                              ? Colors.yellowAccent
                              : Colors.white70),
                      "${widget.data?["city_name"] ?? ""}")),
              // Expanded(child: Text(style: colorStyle(isSmall: true), data["VIA"])),
              // Expanded(child: Text(style: colorStyle(isSmall: true), data['_path'])),
              Expanded(
                  child: Text(
                      style: colorStyle(
                          isSmall: true,
                          isBold: true,
                          color: widget.isBold
                              ? Colors.yellowAccent
                              : Colors.white70),
                      '${widget.data?["status"] ?? ""}')),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                child: Icon(
                  widget.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  size: 15,
                  color: Colors.yellowAccent,
                ),
              )

              /*Expanded(
                child: Text(
                    style: colorStyle(isSmall: true),
                    "${data["estmtd_real_time"]}")),*/
            ],
          ),
        ),
        const Divider(
          color: Colors.white54,
        ),
      ],
    );
  }
}
