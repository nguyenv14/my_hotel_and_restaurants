import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/login/components/InputFieldComponet.dart';
import 'package:my_hotel_and_restaurants/view/product/components/line_component.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';

class CommentComponent extends StatefulWidget {
  final OrderViewModel orderViewModel;
  final OrderModel orderModel;
  const CommentComponent(
      {super.key, required this.orderViewModel, required this.orderModel});

  @override
  State<CommentComponent> createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  int service = 0;
  int convinient = 0;
  int position = 0;
  int price = 0;
  int vesinh = 0;
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đánh giá 🏨"),
      content: SizedBox(
        height: context.mediaQueryHeight * 0.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dịch vụ: ",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      service = rating.toInt();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Giá cả: ",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      price = rating.toInt();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vị trí: ",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      position = rating.toInt();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thuận tiện: ",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      convinient = rating.toInt();
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vệ sinh: ",
                  style: MyTextStyle.textStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 15,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      vesinh = rating.toInt();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const LineComponent(),
            const SizedBox(
              height: 5,
            ),
            const Text("Bình luận"),
            const SizedBox(
              height: 5,
            ),
            InputFieldComponent(
              titleText: "Comment",
              hintText: "Nhập bình luận...",
              iconData: FontAwesomeIcons.comment,
              textEditingController: textEditingController,
              color: Colors.pinkAccent[100]!,
              // isPassword: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng hộp thoại
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            widget.orderViewModel.sendCommentToOrder(
                CustomerDB.getCustomer()!.customer_id!,
                widget.orderModel.orderId,
                widget.orderModel.orderDetailsModel!.hotelId,
                widget.orderModel.orderDetailsModel!.roomId,
                widget.orderModel.orderDetailsModel!.typeRoomId,
                textEditingController.text,
                price,
                position,
                service,
                vesinh,
                convinient);
            Navigator.of(context).pop();
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
