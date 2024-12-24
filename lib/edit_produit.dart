import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProduitForm extends StatefulWidget {
  final Map<String, dynamic> produit;

  const EditProduitForm({Key? key, required this.produit}) : super(key: key);

  @override
  State<EditProduitForm> createState() => _EditProduitFormState();
}

class _EditProduitFormState extends State<EditProduitForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _libelleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prixController;
  String? _photoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _libelleController = TextEditingController(text: widget.produit['libelle']);
    _descriptionController = TextEditingController(text: widget.produit['description']);
    _prixController = TextEditingController(text: widget.produit['prix'].toString());
    _photoUrl = widget.produit['photoUrl'];
  }

  @override
  void dispose() {
    _libelleController.dispose();
    _descriptionController.dispose();
    _prixController.dispose();
    super.dispose();
  }

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

  Future<void> updateProduct() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('https://iouxy8p964.execute-api.us-east-1.amazonaws.com/dev/product');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "body": {
        "productId": widget.produit['id'],
        "libelle": _libelleController.text,
        "description": _descriptionController.text,
        "prix": double.parse(_prixController.text),
        "photoUrl": _photoUrl
      }
    };

    try {
      final response = await http.patch(url, headers: headers, body: jsonEncode(body));
      
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produit modifié avec succès'))
        );
        Navigator.pop(context, true); // Return true to indicate successful update
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
            if (_photoUrl != null) ...[
              const SizedBox(height: 10),
              Image.network(
                _photoUrl!,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Error loading image'));
                },
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formKey.currentState?.validate() ?? false) {
                        updateProduct();
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}