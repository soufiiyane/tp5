import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProduitForm extends StatefulWidget {
  const AddProduitForm({super.key});

  @override
  State<AddProduitForm> createState() => _AddProduitFormState();
}

class _AddProduitFormState extends State<AddProduitForm> {
  final _formKey = GlobalKey<FormState>();
  String? _libelle, _description, _photoUrl;
  double? _prix;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64Image';
      
      setState(() {
        _photoUrl = dataUrl;
      });
    }
  }

  Future<void> submitProduct() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://iouxy8p964.execute-api.us-east-1.amazonaws.com/dev/product');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "body": {
        "libelle": _libelle,
        "description": _description,
        "prix": _prix,
        "photoUrl": _photoUrl
      }
    };

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit ajouté avec succès'))
        );
        Navigator.pop(context); // Go back to the list after successful submission
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.body}'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau: $e'))
      );
    } finally {
      setState(() {
        _isLoading = false;
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
              onSaved: (value) => _libelle = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              onSaved: (value) => _description = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Champ requis';
                if (double.tryParse(value!) == null) return 'Prix invalide';
                return null;
              },
              onSaved: (value) => _prix = double.parse(value ?? '0'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Sélectionner une image'),
            ),
            if (_photoUrl != null) ...[
              const SizedBox(height: 10),
              Image.network(_photoUrl!, height: 200),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        submitProduct();
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
