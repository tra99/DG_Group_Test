import 'package:dg_group/model/video_item_model.dart';
import 'package:dg_group/screen/video_thumnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    const pageSize = 15;

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
          SnackBar(content: Text('Error loading videos: $e')),
        );
        print('Error loading videos: $e');
      } finally {
        isLoading.value = false;
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      }
    }

    useEffect(() {
      loadItems();
      return null;
    }, []);

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          loadItems();
        }
      });
      return null;
    }, [scrollController]);

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Videos')),
      body: isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: refreshController,
              enablePullUp: true,
              onRefresh: () => loadItems(refresh: true),
              onLoading: () => loadItems(),
              child: ListView.builder(
                controller: scrollController,
                itemCount: items.value.length,
                itemBuilder: (context, index) {
                  final item = items.value[index];
                  return VideoThumbnailItem(item: item);
                },
              ),
            ),
    );
  }
}