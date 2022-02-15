import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/util/helpers.dart';
import 'package:path_provider/path_provider.dart';

class Invoice extends StatefulWidget {
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  late int index;
  bool _isLoading = true;
  String pathPDF = "";
  int? _totalPage = 1;
  int? _currentPage = 1;

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
      setState(() {
        _isLoading = false;
      });
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
            : Stack(children: [
                PDFView(
                  filePath: pathPDF,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  preventLinkNavigation: false,
                  onRender: (pages) {
                    // _pages = pag
                    // if (pages != null) {
                    //   List newList = [];

                    //   for (int i = 0; i < pages; i++) {
                    //     newList.add(i);
                    //   }

                    //   print("#NEWLIST: $newList");

                    setState(() {
                      _totalPage = pages;
                    });
                    // }
                  },
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                  onPageChanged: (int? page, int? total) {
                    print('page change: $page/$total');
                    if (page != null) {
                      setState(() {
                        _currentPage = page + 1;
                      });
                    }
                  },
                ),
                Positioned.fill(
                    bottom: 50,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('$_currentPage / $_totalPage')))
              ]),
      ),
    );
  }
}
