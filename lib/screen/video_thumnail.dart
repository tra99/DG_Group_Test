import 'package:cached_network_image/cached_network_image.dart';
import 'package:dg_group/model/video_item_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoThumbnailItem extends StatefulWidget {
  final VideoItem item;

  const VideoThumbnailItem({super.key, required this.item});

  @override
  State<VideoThumbnailItem> createState() => _VideoThumbnailItemState();
}

class _VideoThumbnailItemState extends State<VideoThumbnailItem> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.item.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _playVideo() {
    setState(() {
      _isPlaying = true;
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        placeholder: CachedNetworkImage(
          imageUrl: widget.item.thumbnailUrl,
          fit: BoxFit.cover,
        ),
      );
    });
  }

  void _stopVideo() {
    setState(() {
      _isPlaying = false;
      _chewieController?.dispose();
      _chewieController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          onTap: () {
            if (_isPlaying) {
              _stopVideo();
            } else {
              _playVideo();
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _isPlaying
                      ? Chewie(controller: _chewieController!)
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.item.thumbnailUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.videocam, size: 50),
                              ),
                              memCacheWidth: (width * 1.5).toInt(),
                            ),
                            const Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}