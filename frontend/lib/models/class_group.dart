class ClassGroup {
  final int id;
  final String name;
  final String period;

  const ClassGroup({
    required this.id,
    required this.name,
    required this.period,
  });

  factory ClassGroup.fromMap(Map<String, dynamic> map) => ClassGroup(
        id: map['id'] as int,
        name: map['nome'] as String,
        period: map['periodo'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': name,
        'periodo': period,
      };
}