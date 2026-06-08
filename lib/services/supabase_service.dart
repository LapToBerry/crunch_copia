import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SupabaseService {
  static const String _supabaseUrl =
      'https://sgmobsblilunacocbqdc.supabase.co';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNnbW9ic2JsaWx1bmFjb2NicWRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4OTQ5NjcsImV4cCI6MjA5NjQ3MDk2N30.xkN-aEt7eMQGEVVT8htPyVLgXTo6qu3gb3ILDp5UCZ0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  // Upload bytes (useful for web where there's no local File)
  static Future<String?> uploadProfileImageFromBytes(Uint8List bytes, String ext) async {
    try {
      final bucket = client.storage.from('avatars');
      final id = const Uuid().v4();
      final path = 'profiles/$id.$ext';
      await bucket.uploadBinary(path, bytes, fileOptions: const FileOptions(cacheControl: '3600'));
      final publicUrl = bucket.getPublicUrl(path);
      try {
        final signed = await bucket.createSignedUrl(path, 60);
        if (signed.isNotEmpty) return signed;
      } catch (_) {}
      return publicUrl;
    } catch (e) {
      return null;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Uploads a profile image file to the 'avatars' storage bucket and returns public URL
  static Future<String?> uploadProfileImage(File file) async {
    try {
      final bucket = client.storage.from('avatars');
      final id = const Uuid().v4();
      final ext = file.path.split('.').last;
      final path = 'profiles/$id.$ext';
      final bytes = await file.readAsBytes();
      await bucket.uploadBinary(path, bytes, fileOptions: const FileOptions(cacheControl: '3600'));
      final publicUrl = bucket.getPublicUrl(path);
      // If the bucket is private, publicUrl may not be accessible. Try creating
      // a signed URL as a fallback so the app can display the image immediately.
      try {
        final signed = await bucket.createSignedUrl(path, 60);
        if (signed.isNotEmpty) {
          return signed;
        }
      } catch (_) {
        // ignore and return public url as fallback
      }
      return publicUrl;
    } catch (e) {
      // ignore errors for now
      return null;
    }
  }

  // Update profile fields in 'profiles' table for current user
  static Future<bool> updateProfile(String? userId, Map<String, dynamic> data) async {
    try {
      // If the user is not authenticated, save the profile locally in shared_preferences
      if (userId == null) {
        try {
          final prefs = await SharedPreferences.getInstance();
          const key = 'local_profile_data';
          final payload = Map<String, dynamic>.from(data);
          // store timestamp for reference
          payload['saved_at'] = DateTime.now().toIso8601String();
          await prefs.setString(key, jsonEncode(payload));
          return true;
        } catch (e) {
          // ignore: avoid_print
          print('Failed to save local profile: $e');
          return false;
        }
      }
      // When userId is present, write to Supabase profiles table
      final payload = Map<String, dynamic>.from(data);
      payload['id'] = userId;
      final response = await client.from('profiles').upsert(payload).select().execute();
      if (response.data != null) return true;
      // ignore: avoid_print
      print('Supabase updateProfile failed: response=${response.data ?? response}');
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Exception in updateProfile: $e');
      return false;
    }
  }

  // Fetch followers or following list (simple example)
  static Future<List<Map<String, dynamic>>> getFollowers(String userId, {bool followers = true}) async {
    try {
      // This assumes a relationship table 'follows' with columns: follower_id, following_id
      if (followers) {
        final res = await client.from('follows').select('follower:profiles(id,username,avatar_url)').eq('following_id', userId).execute();
          if (res.data != null) {
            return List<Map<String, dynamic>>.from(res.data as List);
          }
      } else {
        final res = await client.from('follows').select('following:profiles(id,username,avatar_url)').eq('follower_id', userId).execute();
        if (res.data != null) {
          return List<Map<String, dynamic>>.from(res.data as List);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
