import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'produit.dart';
import 'add_produit.dart';
import 'produit_detail.dart';
import 'edit_produit.dart';

class ProduitsList extends StatefulWidget {
  const ProduitsList({super.key});

  @override
  State<ProduitsList> createState() => _ProduitsListState();
}

class _ProduitsListState extends State<ProduitsList> {
  final List<Produit> _produits = [];

  void saveProduit(Produit produit) {
    setState(() {
      _produits.add(produit);
    });
  }

  void deleteProduit(Produit produit) {
    setState(() {
      _produits.remove(produit);
    });
  }

  void updateProduit(Produit oldProduit, Produit newProduit) {
    setState(() {
      final index = _produits.indexOf(oldProduit);
      if (index != -1) {
        _produits[index] = newProduit;
      }
    });
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
      body: _produits.isEmpty
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
                return Dismissible(
                  key: Key(produit.libelle + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmation"),
                          content: Text("Voulez-vous supprimer ${produit.libelle}?"),
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
                  },
                  onDismissed: (direction) {
                    final deletedProduit = produit;
                    final deletedIndex = index;
                    
                    deleteProduit(produit);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${produit.libelle} supprimé'),
                        action: SnackBarAction(
                          label: 'Annuler',
                          onPressed: () {
                            setState(() {
                              _produits.insert(deletedIndex, deletedProduit);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: produit.photoUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                produit.photoUrl,
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
                        produit.libelle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${produit.prix}€',
                        style: const TextStyle(color: Colors.green),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProduitForm(
                                    produit: produit,
                                    onSave: (updatedProduit) {
                                      updateProduit(produit, updatedProduit);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProduitDetails(
                                    produit: produit,
                                    onDelete: deleteProduit,
                                    onUpdate: updateProduit,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProduitDetails(
                              produit: produit,
                              onDelete: deleteProduit,
                              onUpdate: updateProduit,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduitForm(onSave: saveProduit),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}