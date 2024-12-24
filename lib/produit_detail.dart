import 'package:flutter/material.dart';
import 'produit.dart';
import 'edit_produit.dart';

class ProduitDetails extends StatefulWidget {
  final Produit produit;
  final Function(Produit)? onDelete;
  final Function(Produit, Produit)? onUpdate;

  const ProduitDetails({
    super.key, 
    required this.produit,
    this.onDelete,
    this.onUpdate,
  });

  @override
  State<ProduitDetails> createState() => _ProduitDetailsState();
}

class _ProduitDetailsState extends State<ProduitDetails> {
  late Produit _currentProduit;

  @override
  void initState() {
    super.initState();
    _currentProduit = widget.produit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentProduit.libelle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProduitForm(
                    produit: _currentProduit,
                    onSave: (updatedProduit) {
                      setState(() {
                        _currentProduit = updatedProduit;
                      });
                      widget.onUpdate?.call(_currentProduit, updatedProduit);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmation'),
                  content: Text('Voulez-vous supprimer ${_currentProduit.libelle} ?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Non'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Oui'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true && context.mounted) {
                widget.onDelete?.call(_currentProduit);
                Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${_currentProduit.libelle} supprimé'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentProduit.photoUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    _currentProduit.photoUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Icon(Icons.error, size: 50, color: Colors.red),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / 
                                  loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                _currentProduit.description,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                'Prix: ${_currentProduit.prix}€',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}