import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_produit.dart';
import 'edit_produit.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  final List<Map<String, dynamic>> _produits = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProduits();
  }

  Future<void> _fetchProduits() async {
    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'https://iouxy8p964.execute-api.us-east-1.amazonaws.com/dev/product';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> items = json.decode(responseData['body'])['items'];

        setState(() {
          _produits.clear();
          _produits.addAll(items.map((item) => {
            'id': item['ProductId'],
            'libelle': item['Libelle'],
            'description': item['Description'],
            'prix': double.parse(item['Prix']),
            'photoUrl': item['PhotoUrl'],
            'createdAt': DateTime.parse(item['CreatedAt']),
            'updatedAt': DateTime.parse(item['UpdatedAt']),
          }));
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching products: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteProduit(Map<String, dynamic> produit) async {
    const apiUrl = 'https://iouxy8p964.execute-api.us-east-1.amazonaws.com/dev/product';
    
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "body": {
            "productId": produit['id']
          }
        }),
      );

      if (response.statusCode == 200) {
        _fetchProduits();
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      print('Error deleting product: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _produits.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun produit disponible',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _produits.length,
                  itemBuilder: (context, index) {
                    final produit = _produits[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: produit['photoUrl'].isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  "${produit['photoUrl']}?${DateTime.now().millisecondsSinceEpoch}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              )
                            : const Icon(Icons.image),
                        title: Text(
                          produit['libelle'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${produit['prix']}€',
                          style: const TextStyle(color: Colors.green),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProduitForm(produit: produit),
                                  ),
                                );
                                if (result == true) {
                                  _fetchProduits();
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirmation"),
                                      content: Text("Voulez-vous supprimer ${produit['libelle']}?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: const Text("Non"),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: const Text("Oui"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                
                                if (confirm == true) {
                                  await deleteProduit(produit);
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProduitForm(produit: produit),
                            ),
                          );
                          if (result == true) {
                            _fetchProduits();
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduitForm(),
            ),
          );
          _fetchProduits();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}