import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'produit.dart';
import 'package:universal_html/html.dart' as html;

class AddProduitForm extends StatefulWidget {
  final Function(Produit) onSave;

  const AddProduitForm({super.key, required this.onSave});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  final _produit = Produit();
  String? _imageDataUrl;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = html.window.btoa(String.fromCharCodes(bytes));
      final dataUrl = 'data:image/jpeg;base64,$base64Image';
      
      setState(() {
        _imageDataUrl = dataUrl;
        _produit.photoUrl = dataUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter un produit")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Libellé'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              onSaved: (value) => _produit.libelle = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              onSaved: (value) => _produit.description = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Champ requis';
                if (double.tryParse(value!) == null) return 'Prix invalide';
                return null;
              },
              onSaved: (value) => _produit.prix = double.parse(value ?? '0'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Sélectionner une image'),
            ),
            if (_imageDataUrl != null) ...[
              const SizedBox(height: 10),
              Image.network(_imageDataUrl!, height: 200),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  widget.onSave(_produit);
                  Navigator.pop(context);
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}