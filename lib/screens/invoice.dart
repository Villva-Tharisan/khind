import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:khind/themes/app_colors.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/helpers.dart';
import 'package:path_provider/path_provider.dart';

class Invoice extends StatefulWidget {
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late int index;
  bool _isLoading = true;
  String pathPDF = "";

  // late PDFDocument document;

  @override
  void initState() {
    loadDocument();
    super.initState();
  }

  loadDocument() async {
    // document = await PDFDocument.fromAsset('assets/docs/invoice.pdf');
    // setState(() => _isLoading = false);
    fromAsset('assets/docs/invoice.pdf', 'invoice.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
      });
    });
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helpers.customAppBar(
        context,
        _scaffoldKey,
        title: "Invoice",
        isBack: true,
        hasActions: false,
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.grey))
            : PDFView(
                filePath: pathPDF,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                onRender: (_pages) {
                  // setState(() {
                  //   pages = _pages;
                  //   isReady = true;
                  // });
                },
                onError: (error) {
                  print(error.toString());
                },
                onPageError: (page, error) {
                  print('$page: ${error.toString()}');
                },
                // onViewCreated: (PDFViewController pdfViewController) {
                //   _controller.complete(pdfViewController);
                // },
                // onPageChanged: (int page, int total) {
                //   print('page change: $page/$total');
                // },
              ),
        // : PDFViewer(
        //     document: document,
        //     zoomSteps: 1,
        //     //uncomment below line to preload all pages
        //     // lazyLoad: false,
        //     // uncomment below line to scroll vertically
        //     // scrollDirection: Axis.vertical,

        //     //uncomment below code to replace bottom navigation with your own
        //     /* navigationBuilder:
        //               (context, page, totalPages, jumpToPage, animateToPage) {
        //             return ButtonBar(
        //               alignment: MainAxisAlignment.spaceEvenly,
        //               children: <Widget>[
        //                 IconButton(
        //                   icon: Icon(Icons.first_page),
        //                   onPressed: () {
        //                     jumpToPage()(page: 0);
        //                   },
        //                 ),
        //                 IconButton(
        //                   icon: Icon(Icons.arrow_back),
        //                   onPressed: () {
        //                     animateToPage(page: page - 2);
        //                   },
        //                 ),
        //                 IconButton(
        //                   icon: Icon(Icons.arrow_forward),
        //                   onPressed: () {
        //                     animateToPage(page: page);
        //                   },
        //                 ),
        //                 IconButton(
        //                   icon: Icon(Icons.last_page),
        //                   onPressed: () {
        //                     jumpToPage(page: totalPages - 1);
        //                   },
        //                 ),
        //               ],
        //             );
        //           }, */
        //   ),
      ),
    );
  }
}
