class Produtor {
  final int id;
  final String nome;
  final String sobrenome;
  final String endereco;
  final String telefone;
  final String contaB;

  Produtor({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.endereco,
    required this.telefone,
    required this.contaB,
  });

  String get nomeCompleto {
    return '$nome $sobrenome';
  }

  factory Produtor.fromJson(Map<String, dynamic> json) {
    return Produtor(
      id: json['id'],
      nome: json['Nome'],
      sobrenome: json['Sobrenome'],
      endereco: json['Endereço'],
      telefone: json['Telefone'],
      contaB: json['Conta Bancaria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Nome': nome,
      'Sobrenome': sobrenome,
      'Endereço': endereco,
      'Telefone': telefone,
      'Conta Bancaria': contaB,
    };
  }
}
