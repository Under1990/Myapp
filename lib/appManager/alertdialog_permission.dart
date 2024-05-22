import 'package:flutter/material.dart';

class AlertDialogPermission extends StatefulWidget {
  final String title;
  final String description;
  final String textLeft;
  final String textRight;
  final BuildContext mainContext;
  final Function(bool) callbackFunction;
  const AlertDialogPermission({Key? key, required this.title, required this.description, required this.textLeft, required this.textRight, required this.mainContext, required this.callbackFunction}) : super(key: key);

  @override
  State<AlertDialogPermission> createState() => _AlertDialogPermissionState();
}

class _AlertDialogPermissionState extends State<AlertDialogPermission> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.circular(Consts.padding),
//      ),
//       insetPadding: EdgeInsets.all(0),
      // elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.25,
      // width: MediaQuery.of(context).size.width*0.9,
//            padding: EdgeInsets.all(16),
//            margin: EdgeInsets.symmetric(horizontal: 64),
      decoration: new BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
          //   alignment: Alignment.topCenter,
          //   child: Image.asset(
          //     alertImage,
          //     height: 88,
          //     width: 88,
          //     color: Theme.of(context).primaryColor,
          //   ),
          // ),
          Container(
            // height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 1 ,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: new Text('${widget.description}',
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    // color: Theme.of(context).disabledColor,
                    // fontWeight: FontWeight.w500,
                  )),
            ),
          ),
          Container(
            // height: 64,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        widget.callbackFunction(true);
                      }, child: Text(widget.textLeft,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight:FontWeight.bold),)),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        widget.callbackFunction(false);
                      }, child: Text(widget.textRight,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight:FontWeight.bold),)),
                ],
              )),
        ],
      ),
    );
  }
}
