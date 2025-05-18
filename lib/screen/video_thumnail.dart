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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  Future<void> _initializeVideoController() async {
    _videoController = VideoPlayerController.network(widget.item.videoUrl);
    try {
      await _videoController.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _playVideo() {
    if (!_isInitialized) return;
    
    setState(() {
      _isPlaying = true;
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        placeholder: Container(
          color: Colors.grey[300],
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.item.thumbnailUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'Error loading video',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    });
  }

  void _stopVideo() {
    setState(() {
      _isPlaying = false;
      _chewieController?.dispose();
      _chewieController = null;
      _videoController.pause();
      _videoController.seekTo(Duration.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateText = '${now.day}/${now.month}/${now.year}';

    return LayoutBuilder(
      builder: (context, constraints) {
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
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _isPlaying && _chewieController != null
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
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.videocam, size: 50),
                              ),
                            ),
                            if (!_isPlaying)
                              const Icon(
                                Icons.play_circle_fill,
                                size: 50,
                                color: Colors.white70,
                              ),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Date
                      Text(
                        dateText,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Video title (expanded to take available space)
                      Expanded(
                        child: Text(
                          widget.item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      
                      // Notification button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 35, 35, 35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications, 
                                 color: Colors.yellow[600], 
                                 size: 20),
                            const SizedBox(width: 4),
                            Text(
                              'Đặt lịch',
                              style: TextStyle(
                                color: Colors.yellow[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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