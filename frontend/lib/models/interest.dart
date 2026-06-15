class Interest {
  final int id;
  final int empresaId;
  final String empresaNome;
  final int projetoId;
  final String projetoTitulo;
  final int alunoId;
  final DateTime date;

  const Interest({
    required this.id,
    required this.empresaId,
    required this.empresaNome,
    required this.projetoId,
    required this.projetoTitulo,
    required this.alunoId,
    required this.date,
  });
}
