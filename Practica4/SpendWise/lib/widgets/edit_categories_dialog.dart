import 'package:flutter/material.dart';

class EditCategoriesDialog extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<List<String>> onCategoriesChanged;


  const EditCategoriesDialog({
    super.key,
    required this.categories,
    required this.onCategoriesChanged,
  });

  @override
  State<EditCategoriesDialog> createState() => _EditCategoriesDialogState();
}

class _EditCategoriesDialogState extends State<EditCategoriesDialog> {
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = List<String>.from(widget.categories);
  }

  void _addCategory() {
    setState(() {
      categories.add('Nueva categoría');
    });
  }

  void _removeCategory(int index) {
    setState(() {
      categories.removeAt(index);
    });
  }

  void _updateCategory(int index, String value) {
    setState(() {
      categories[index] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar categorías'),
      content: SizedBox(
        width: 350,
        child: ReorderableListView(
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = categories.removeAt(oldIndex);
              categories.insert(newIndex, item);
            });
          },
          children: [
            for (int i = 0; i < categories.length; i++)
              ListTile(
                key: ValueKey(categories[i]),
                title: TextFormField(
                  initialValue: categories[i],
                  onChanged: (val) => _updateCategory(i, val),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeCategory(i),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _addCategory,
          child: const Text('Añadir'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onCategoriesChanged(categories);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
