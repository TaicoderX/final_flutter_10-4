import 'package:flutter/material.dart';
import 'package:shop_app/screens/add_folder/components/choose_folder.dart';

class ChooseFolderFactory {
  static List<String> alreadyFolderAdded = [];
  static List<String> newlySelectedFolders = [];
  static List<String> deselectedFolders = [];

  static Widget createWidget(
    Map<String, dynamic> folder,
    BuildContext context,
    bool isLarge,
    String image,
    String name, {
    required void Function() refreshUI,
  }) {
    String folderId = folder['_id'];
    bool isSelected = alreadyFolderAdded.contains(folderId)
        ? !deselectedFolders.contains(folderId)
        : newlySelectedFolders.contains(folderId);

    return FolderAdded(
      title: folder['folderNameEnglish'] ?? '',
      image: image,
      words: folder['topicCount'] ?? 0,
      name: name,
      sets: folder['topicCount'] ?? 0,
      isLarge: isLarge,
      isSelected: isSelected,
      press: () {
        if (alreadyFolderAdded.contains(folderId)) {
          if (deselectedFolders.contains(folderId)) {
            deselectedFolders.remove(folderId);
          } else {
            deselectedFolders.add(folderId);
          }
        } else {
          if (newlySelectedFolders.contains(folderId)) {
            newlySelectedFolders.remove(folderId);
          } else {
            newlySelectedFolders.add(folderId);
          }
        }
        refreshUI();
      },
    );
  }
}
