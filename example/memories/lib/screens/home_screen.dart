import 'package:flutter/material.dart';
import '../models/memory.dart';
import '../services/cloudinary_service.dart';
import '../services/storage_service.dart';
import '../widgets/photo_grid.dart';
import 'add_memory_screen.dart';
import 'photo_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Memory> memories = [];
  final StorageService _storageService = StorageService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemories();
  }

  Future<void> _loadMemories() async {
    final loadedMemories = await _storageService.loadMemories();
    setState(() {
      memories = loadedMemories;
      _isLoading = false;
    });
  }

  Future<void> _saveMemories() async {
    await _storageService.saveMemories(memories);
  }

  void _addMemory() async {
    final result = await Navigator.push<Memory>(
      context,
      MaterialPageRoute(builder: (context) => const AddMemoryScreen()),
    );

    if (result != null) {
      setState(() {
        memories.insert(0, result);
      });
      await _saveMemories();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Memories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: memories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Memories Yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to create your first memory',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: _buildSectionedMemories(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemory,
        tooltip: 'Add Memory',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildSectionedMemories() {
    // Sort by most recent first
    final List<Memory> sorted = [...memories]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Group by title
    final Map<String, List<Memory>> titleToMemories = {};
    for (final m in sorted) {
      titleToMemories.putIfAbsent(m.title, () => []).add(m);
    }

    final List<Widget> widgets = [];
    titleToMemories.forEach((title, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      );

      for (final memory in items) {
        widgets.add(_buildMemoryCard(memory));
      }
    });

    return widgets;
  }

  Widget _buildMemoryCard(Memory memory) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: memory.imagePaths.isNotEmpty
          ? PhotoGrid(
              imagePaths: memory.imagePaths,
              onImageTap: (index) => _openPhotoViewer(memory, index),
            )
          : const SizedBox.shrink(),
    );
  }

  void _openPhotoViewer(Memory memory, int initialIndex) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerScreen(
          imagePaths: memory.imagePaths,
          initialIndex: initialIndex,
          onDelete: (index) async {
            final imageUrl = memory.imagePaths[index];
            
            if (_cloudinaryService.isCloudinaryUrl(imageUrl)) {
              await _cloudinaryService.deleteImage(imageUrl);
            }
            
            setState(() {
              memory.imagePaths.removeAt(index);
              if (memory.imagePaths.isEmpty) {
                memories.remove(memory);
              }
            });
            _saveMemories();
          },
        ),
      ),
    );
  }
}
