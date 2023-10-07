import 'package:bloc_pattren_sample/bloc/app_bloc.dart';
import 'package:bloc_pattren_sample/bloc/app_events.dart';
import 'package:bloc_pattren_sample/bloc/app_state.dart';
import 'package:bloc_pattren_sample/views/main_popup_menu_button.dart';
import 'package:bloc_pattren_sample/views/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(source: ImageSource.gallery);
              if (image == null) return;

              context.read<AppBloc>().add(
                    AppEventUploadImage(filePathToUpload: image.path),
                  );
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: images
            .map(
              (e) => StorageImageView(image: e),
            )
            .toList(),
      ),
    );
  }
}
