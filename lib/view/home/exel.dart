import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spreadsheet_ui/flutter_spreadsheet_ui.dart';


class MyHomePag extends StatefulWidget {
  const MyHomePag({super.key, required this.title});

  final String title;

  @override
  State<MyHomePag> createState() => _MyHomePagState();
}

class _MyHomePagState extends State<MyHomePag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FlutterSpreadsheetUI(
          config: const FlutterSpreadsheetUIConfig(
            enableColumnWidthDrag: true,
            enableRowHeightDrag: true,
            firstColumnWidth: 150,
            freezeFirstColumn: true,
            freezeFirstRow: true,
          ),
          columnWidthResizeCallback: (int columnIndex, double updatedWidth) {
            log("Column: $columnIndex's updated width: $updatedWidth");
          },
          rowHeightResizeCallback: (int rowIndex, double updatedHeight) {
            log("Row: $rowIndex's updated height: $updatedHeight");
          },
          columns: [
            FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => const Text("Date"),
            ),
           
            // FlutterSpreadsheetUIColumn(
            //   width: 110,
            //   cellBuilder: (context, cellId) => const Text("Permissions"),
            // ),
            ...List.generate(
              2,
              (index) => FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => Text("Ajmal$index")),
            
            ),
              FlutterSpreadsheetUIColumn(
              contentAlignment: Alignment.center,
              cellBuilder: (context, cellId) => const Text("TotalAmount"),
            ),
           
          ],
          rows: List.generate(
            20,
            (rowIndex) => FlutterSpreadsheetUIRow(
              cells: [

                FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) =>
                      Text('Task ${rowIndex + 1}'),
                ),

           
                //  FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) =>
                //       Text('Task ${rowIndex + 1}'),
                // ),
                // FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) => Text(
                //     DateTime.now().toString(),
                //   ),
                // ),
                // FlutterSpreadsheetUICell(
                //   cellBuilder: (context, cellId) => const Text(
                //     'None',
                //   ),
                // ),

                ...List.generate(
                  2,
                  (colIndex) => 
                  FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) {
                    return Container(
                      child: Text("$colIndex-11-2023".toString()),
                    );
                  }
                  
                  //  Text(
                  //   DateTime.now().toString(),
                  // ),
                ),
                ),
                 FlutterSpreadsheetUICell(
                  cellBuilder: (context, cellId) =>
                      Text('Task ${rowIndex + 1}'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}