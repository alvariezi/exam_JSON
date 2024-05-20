import 'package:exam/services/album_services.dart';
import 'package:flutter/material.dart';
import 'package:exam/models/album.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<Album> album = [];

  void fetchAlbum() async {
    final result = await AlbumService.fetchAlbum();
    setState(() {
      album = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAlbum();
  }

  void deleteAlbum(int index) async {
    try {
      await AlbumService.deleteAlbum(album[index].id);
      setState(() {
        album.removeAt(index);
      });
    } catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete album: $e')),
      );
    }
  }

  void editAlbum(int index, String newTitle, String newUrl, String newThumbnailUrl) async {
    Album updatedAlbum = Album(
      albumId: album[index].albumId,
      id: album[index].id,
      title: newTitle,
      url: newUrl,
      thumbnailUrl: newThumbnailUrl,
    );

    try {
      await AlbumService.editAlbum(updatedAlbum);
      setState(() {
        album[index] = updatedAlbum;
      });
    } catch (e) {
      // Handle error
    }
  }

  void addAlbum(int albumId, String title, String url, String thumbnailUrl) async {
    Album newAlbum = Album(
      albumId: albumId,
      id: album.isNotEmpty ? album.last.id + 1 : 1,
      title: title,
      url: url,
      thumbnailUrl: thumbnailUrl,
    );

    try {
      await AlbumService.addAlbum(newAlbum);
      setState(() {
        album.add(newAlbum);
      });
    } catch (e) {
      // Handle error
    }
  }

  void showAddDialog(BuildContext context) {
    TextEditingController albumIdController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController urlController = TextEditingController();
    TextEditingController thumbnailUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: albumIdController,
                decoration: InputDecoration(labelText: 'Album ID'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red), 
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
              ),
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green), 
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
              ),
              child: Text('Tambah'),
              onPressed: () {
                addAlbum(
                  int.parse(albumIdController.text),
                  titleController.text,
                  urlController.text,
                  thumbnailUrlController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(BuildContext context, int index) {
    TextEditingController titleController = TextEditingController(text: album[index].title);
    TextEditingController urlController = TextEditingController(text: album[index].url);
    TextEditingController thumbnailUrlController = TextEditingController(text: album[index].thumbnailUrl);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: urlController,
                decoration: InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Simpan'),
              onPressed: () {
                editAlbum(index, titleController.text, urlController.text, thumbnailUrlController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Exam JSON and rest API',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w800,
        ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showAddDialog(context);
            },
            color: Colors.black,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: album.length,
        itemBuilder: (context, index) {
          final albumItem = album[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(albumItem.thumbnailUrl),
              ),
              title: Text('${albumItem.id}. ${albumItem.title}'),
              subtitle: Text(albumItem.url),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit_road_outlined),
                    color: Colors.blue,
                    onPressed: () {
                      showEditDialog(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      deleteAlbum(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
   );
  }
}