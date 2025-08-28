import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pagination extends StatefulWidget {
  final int currentPage; // Recibe la página actual (0-indexed del backend)
  final int totalPages; // Recibe el total de páginas
  final int itemsPerPage; // Recibe el tamaño de página actual
  final List<int> availableItemsPerPage; // Recibe las opciones para el dropdown
  final ValueChanged<int> onPageChanged; // Notifica cambio de página
  final ValueChanged<int>
  onItemsPerPageChanged; // Notifica cambio de tamaño de página

  const Pagination({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.onItemsPerPageChanged,
    this.itemsPerPage = 10,
    this.availableItemsPerPage = const [10, 25, 50, 100],
  }) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  late TextEditingController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController();
    // Sincroniza el texto con la página actual (+1 para mostrar al usuario)
    _pageController.text = (widget.currentPage + 1).toString();
  }

  @override
  void didUpdateWidget(Pagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la página actual cambia desde fuera, actualiza el campo de texto
    if (widget.currentPage != oldWidget.currentPage) {
      _pageController.text = (widget.currentPage + 1).toString();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage() {
    final pageNumberInput = int.tryParse(_pageController.text);
    if (pageNumberInput != null &&
        pageNumberInput >= 1 &&
        pageNumberInput <= widget.totalPages) {
      // Notifica al padre para que cambie a la página (restando 1 para que sea 0-indexed)
      widget.onPageChanged(pageNumberInput - 1);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Página inválida')));
      // Resetea el texto al valor correcto
      _pageController.text = (widget.currentPage + 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPageControls(isMobile),
                const SizedBox(height: 4),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPerPageDropdown(),
                const SizedBox(width: 15),
                _buildPageControls(isMobile),
                const SizedBox(width: 15),
                _buildGoToPage(isMobile),
                const SizedBox(width: 15),
                _buildGoButton(),
              ],
            ),
    );
  }

  Widget _buildPageControls(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.red[700]),
          onPressed: widget.currentPage > 0
              ? () => widget.onPageChanged(widget.currentPage - 1)
              : null,
        ),
        Text(
          // Si no hay páginas, muestra "Página 0 de 0", si no, suma 1 para el usuario.
          'Página ${widget.totalPages == 0 ? 0 : widget.currentPage + 1} de ${widget.totalPages}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.red[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward, color: Colors.red[700]),
          onPressed: widget.currentPage < widget.totalPages - 1
              ? () => widget.onPageChanged(widget.currentPage + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildGoToPage(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Ir a página:',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 35,
          width: 50,
          child: TextFormField(
            controller: _pageController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 2.0),
              border: OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) => _goToPage(),
          ),
        ),
      ],
    );
  }

  Widget _buildPerPageDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Elementos por página:',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(width: 10),
        DropdownButton<int>(
          value: widget.itemsPerPage,
          onChanged: (value) {
            if (value != null) {
              widget.onItemsPerPageChanged(value);
            }
          },
          items: widget.availableItemsPerPage.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGoButton() {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        onPressed: _goToPage,
        child: const Text('Ir'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }

  Widget _buildSizeAndGoControls(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPerPageDropdown(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGoToPage(isMobile),
            const SizedBox(width: 5),
            _buildGoButton(),
          ],
        ),
      ],
    );
  }
}
