import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'produit.dart';
import 'package:universal_html/html.dart' as html;

class EditProduitForm extends StatefulWidget {
  final Produit produit;
  final Function(Produit) onSave;

  const EditProduitForm({
    super.key,
    required this.produit,
    required this.onSave,
  });

  @override
  State<EditProduitForm> createState() => _EditProduitFormState();
}

class _EditProduitFormState extends State<EditProduitForm> {
  final _formKey = GlobalKey<FormState>();
  late String? _imageDataUrl;
  late TextEditingController _libelleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixController;

  @override
  void initState() {
    super.initState();
    _imageDataUrl = widget.produit.photoUrl;
    _libelleController = TextEditingController(text: widget.produit.libelle);
    _descriptionController = TextEditingController(text: widget.produit.description);
    _prixController = TextEditingController(text: widget.produit.prix.toString());
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = html.window.btoa(String.fromCharCodes(bytes));
      final dataUrl = 'data:image/jpeg;base64,$base64Image';
      
      setState(() {
        _imageDataUrl = dataUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le produit")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _libelleController,
              decoration: const InputDecoration(labelText: 'Libellé'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            TextFormField(
              controller: _prixController,
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Champ requis';
                if (double.tryParse(value!) == null) return 'Prix invalide';
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Modifier l\'image'),
            ),
            if (_imageDataUrl != null) ...[
              const SizedBox(height: 10),
              Image.network(_imageDataUrl!, height: 200),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final updatedProduit = Produit(
                    libelle: _libelleController.text,
                    description: _descriptionController.text,
                    prix: double.parse(_prixController.text),
                    photoUrl: _imageDataUrl ?? '',
                  );
                  widget.onSave(updatedProduit);
                  Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _libelleController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    super.dispose();
  }
}