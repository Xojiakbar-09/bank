import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String email;
  final String? avatarUrl;
  final ImageProvider? localImage;
  final bool isLoading;
  final VoidCallback onTapAvatar;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.localImage,
    required this.isLoading,
    required this.onTapAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTapAvatar,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: const Color(0xFF1E222B),
                    backgroundImage: localImage ??
                        (avatarUrl != null ? NetworkImage(avatarUrl!) as ImageProvider : null),
                    child: (localImage == null && avatarUrl == null)
                        ? const Icon(Icons.person, size: 45, color: Colors.white70)
                        : null,
                  ),
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}