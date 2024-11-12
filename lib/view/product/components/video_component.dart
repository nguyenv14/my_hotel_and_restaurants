// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoComponent extends StatefulWidget {
//   final String videoPath;
//   const VideoComponent({super.key, required this.videoPath});

//   @override
//   State<VideoComponent> createState() => _VideoComponentState();
// }

// class _VideoComponentState extends State<VideoComponent> {
//   // late VideoPlayerController _videoPlayerController;
//   late FlickManager flickManager;
//   bool controllerInitisialized = false;

//   String string =
//       "http://192.168.1.34/DoAnCoSo2/public/fontend/assets/img/hotel/gallery_TheBlossomResortIsland/35209_MYTOUR13.mp4";
//   @override
//   void initState() {
//     super.initState();
//     // _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(string))
//     //   ..initialize()
//     //       .then((_) => setState(() {
//     //             controllerInitisialized = true;
//     //             _videoPlayerController.play();
//     //           }))
//     //       .onError((error, stackTrace) => print("jaja " + error.toString()));
//     flickManager = FlickManager(
//       videoPlayerController:
//           VideoPlayerController.networkUrl(Uri.parse(widget.videoPath)),
//       autoPlay: false,
//     );
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     flickManager.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: GestureDetector(
//       onTap: () {},
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 40),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
//         child: AspectRatio(
//             aspectRatio: 16 / 10,
//             child: FlickVideoPlayer(
//               flickManager: flickManager,
//             )),
//       ),
//     ));
//   }
// }
