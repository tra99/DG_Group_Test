import 'package:cached_network_image/cached_network_image.dart';
import 'package:dg_group/model/video_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

const String pexelsApiKey = 'bEZ8jaO0sgFARBvocsrXMFgQUFUXuMvVvtdSNGcjJDjleDykPXOGKUj6';
const String pexelsBaseUrl = 'https://api.pexels.com/videos';

class VideoThumbnailList extends HookWidget {
  const VideoThumbnailList({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState<bool>(true);
    final items = useState<List<VideoItem>>([]);
    final refreshController = RefreshController();
    final scrollController = useScrollController();
    final page = useState<int>(1);
    // At least 8 items should be visible per screen at any time
    const pageSize = 15;

    // Render a list containing at least 5 million items, ensuring smooth scrolling.
    Future<List<VideoItem>> fetchVideos(int page) async {
      final response = await http.get(
        Uri.parse('$pexelsBaseUrl/popular?per_page=$pageSize&page=$page'),
        headers: {'Authorization': pexelsApiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<VideoItem>.from(data['videos'].map((video) {
          final videoFile = video['video_files']
              .firstWhere((file) => file['quality'] == 'sd', orElse: () => video['video_files'][0]);
          
          return VideoItem(
            id: video['id'].toString(),
            title: video['user']['name'],
            videoUrl: videoFile['link'],
            thumbnailUrl: video['image'],
          );
        }));
      } else {
        throw Exception('Failed to load videos');
      }
    }

    Future<void> loadItems({bool refresh = false}) async {
      if (refresh) {
        page.value = 1;
        items.value = [];
      }

      try {
        final newItems = await fetchVideos(page.value);
        items.value = [...items.value, ...newItems];
        page.value++;
      } catch (e) {
        refreshController.refreshFailed();
        refreshController.loadFailed();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading videos: ${e.toString()}')),
        );
      } finally {
        isLoading.value = false;
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      }
    }
    // Implement pagination (lazy loading or infinite scroll) to fetch data dynamically.
    useEffect(() {
      loadItems();
      return () {
        scrollController.dispose();
      };
    }, []);

    useEffect(() {
      void listener() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          loadItems();
        }
      }
      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    return isLoading.value
        ? const Center(child: CircularProgressIndicator(color: Colors.blue,))
        // Support pull-to-refresh functionality to reload the entire list
        : SmartRefresher(
            controller: refreshController,
            enablePullUp: true,
            onRefresh: () => loadItems(refresh: true),
            onLoading: () => loadItems(),
            child: ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.value.length,
              itemBuilder: (context, index) {
                final item = items.value[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: VideoThumbnailCard(item: item),
                );
              },
            ),
          );
  }
}

class VideoThumbnailCard extends StatefulWidget {
  final VideoItem item;

  const VideoThumbnailCard({super.key, required this.item});

  @override
  State<VideoThumbnailCard> createState() => _VideoThumbnailCardState();
}

class _VideoThumbnailCardState extends State<VideoThumbnailCard> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.network(widget.item.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
        }
      }).catchError((error) {
        if (mounted) {
          setState(() => _isInitialized = false);
        }
      });
  }

  void _toggleVideo() {
    if (!_isInitialized) return;
    
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
          aspectRatio: 16 / 9,
          placeholder: _buildThumbnail(),
          errorBuilder: (context, error) => _buildThumbnail(),
        );
      } else {
        _chewieController?.dispose();
        _chewieController = null;
        _videoController.pause();
        _videoController.seekTo(Duration.zero);
      }
    });
  }
  // Each item in the list must display a thumbnail from a video (NOT A STATIC IMAGE)
  Widget _buildThumbnail() {
    // Optimize thumbnail loading: Candidates can be hinted to download and cache thumbnails from a video URL instead of fetching them repeatedly.
    return CachedNetworkImage(
      imageUrl: widget.item.thumbnailUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator(color: Colors.blue,)),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.videocam, size: 50),
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The video can be sourced from any platform, and only one random frame from the video should be displayed—video playback is not required.
    return GestureDetector(
      onTap: _toggleVideo,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _isPlaying && _chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : _buildThumbnail(),
                    if (!_isPlaying)
                      const Icon(
                        Icons.play_circle_fill,
                        size: 50,
                        color: Colors.white70,
                      ),
                  ],
                ),
              ),
            ),
            
            // Info Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.notifications, 
                            color: Colors.yellow[600], 
                            size: 16),
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
  }
}