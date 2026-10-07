import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../network/api_service/api_service.dart';

class YoutubeViewModel extends ChangeNotifier {
  bool isLoading = false;

  // final String apiKey = "AIzaSyDF9p2HrVYkqVDTngv4rFXV7RlP1zYv14c";//MP
  final String apiKey = "AIzaSyAHwDWdk0cWtRj35IyUfOcwBORkHk1Z3d8"; //GCCI
  // final String channelId = "UCW4rtmBUAzr9AVctH9hcKEQ"; // MP
  final String channelId = "UCGAAAgyTUtpCPv6aOk2mTWQ"; //GCCI
  String? errorMessage;

  // String? nextPageToken;
  // bool hasMore = true;
  // bool isLoadMore = false;
  final List<Map<String, String>> video = [];

  String? nextPageToken;
  bool hasMore = true;
  bool isLoadMore = false;
  String? uploadsPlaylistId;

  Future<void> loadInitialData(BuildContext context) async {
    await getUploadsPlaylist();
    await getChannelVideos();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getUploadsPlaylist() async {
    _setLoading(true);

    try {
      // final res = await _dio.get(
      //   "https://www.googleapis.com/youtube/v3/channels",
      //   queryParameters: {
      //     "key": apiKey,
      //     "id": channelId,
      //     "part": "contentDetails"
      //   },
      // );
      //
      // uploadsPlaylistId = res
      //     .data["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"];

      final response = await ApiService.instance.get(
        "https://www.googleapis.com/youtube/v3/channels",
        queryParameters: {
          "key": apiKey,
          "id": channelId,
          "part": "contentDetails",
        },
      );

      //return response.data["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"];
      uploadsPlaylistId = response
          .data["items"][0]["contentDetails"]["relatedPlaylists"]["uploads"];
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;

        if (data != null && data["error"] != null) {
          errorMessage = data["error"]["message"];
        } else {
          errorMessage = "Network error occurred";
        }
        if (errorMessage!.contains("quota")) {
          errorMessage = "YouTube API quota exceeded. Try again tomorrow.";
        }
      } else {
        errorMessage = "";
      }
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getChannelVideos({bool loadMore = false}) async {
    try {
      if (uploadsPlaylistId == null) return;

      // Prevent multiple calls
      if (isLoading) return;

      isLoading = true;
      notifyListeners();

      if (!loadMore) {
        video.clear();
        nextPageToken = null;
        hasMore = true;
      }

      final response = await ApiService.instance.get(
        "https://www.googleapis.com/youtube/v3/playlistItems",
        queryParameters: {
          "key": apiKey,
          "playlistId": uploadsPlaylistId,
          "part": "snippet",
          "maxResults": 10,
          if (nextPageToken != null) "pageToken": nextPageToken,
        },
      );

      final data = response.data;

      final items = data["items"];

      nextPageToken = data["nextPageToken"];

      if (nextPageToken == null) {
        hasMore = false;
      }

      for (var item in items) {
        final snippet = item["snippet"];
        final videoId = snippet["resourceId"]["videoId"];

        video.add({
          "ID": videoId,
          "message": snippet["title"],
          "thumbnail": snippet["thumbnails"]["high"]["url"],
          "created_at": snippet["publishedAt"],
        });
      }
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;

        if (data != null && data["error"] != null) {
          errorMessage = data["error"]["message"];
        } else {
          errorMessage = "Network error occurred";
        }

        if (errorMessage!.contains("quota")) {
          errorMessage = "YouTube API quota exceeded. Try again tomorrow.";
        }
      } else {
        errorMessage = "";
      }
    }

    isLoading = false;
    notifyListeners();
  }


/*  Future<void> getChannelVideos({bool loadMore = false}) async {
    try {
      if (uploadsPlaylistId == null) return;

      // Prevent multiple calls
      if (isLoading) return;

      if (loadMore) {
        if (isLoadMore || !hasMore) return;
        isLoadMore = true;
      } else {
        isLoading = true;
        video.clear();
        nextPageToken = null;
        hasMore = true;
      }

      notifyListeners();

      final res = await _dio.get(
        "https://www.googleapis.com/youtube/v3/playlistItems",
        queryParameters: {
          "key": apiKey,
          "playlistId": uploadsPlaylistId,
          "part": "snippet",
          "maxResults": 20,
          if (nextPageToken != null) "pageToken": nextPageToken,
        },
      );

      final data = res.data;

      final items = data["items"];

      nextPageToken = data["nextPageToken"];

      if (nextPageToken == null) {
        hasMore = false;
      }

      for (var item in items) {
        final snippet = item["snippet"];
        final videoId = snippet["resourceId"]["videoId"];

        video.add({
          "ID": videoId,
          "message": snippet["title"],
          "thumbnail": snippet["thumbnails"]["high"]["url"],
          "created_at": snippet["publishedAt"],
        });
      }
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;

        if (data != null && data["error"] != null) {
          errorMessage = data["error"]["message"];
        } else {
          errorMessage = "Network error occurred";
        }

        if (errorMessage!.contains("quota")) {
          errorMessage = "YouTube API quota exceeded. Try again tomorrow.";
        }
      } else {
        errorMessage = "Unexpected error";
      }
    }

    isLoading = false;
    isLoadMore = false;
    notifyListeners();
  }*/

  Future<void> openYoutube(String videoId) async {
    final url = Uri.parse("https://www.youtube.com/watch?v=$videoId");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
