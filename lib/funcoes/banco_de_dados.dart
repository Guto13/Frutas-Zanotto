// ignore_for_file: depend_on_referenced_packages

import 'package:maca_ipe/datas/estoque.dart';
import 'package:supabase/supabase.dart';

// Função para consultar o estoque
Future<Map<String, dynamic>?> consultaEstoqueSC(SupabaseClient supabase,
    int frutaId, int produtorId, int embalagemId) async {
  final response = await supabase
      .from('EstoqueSC')
      .select('*')
      .eq('FrutaId', frutaId)
      .eq('ProdutorId', produtorId)
      .eq('EmbalagemId', embalagemId);

  return response.length > 0 ? response[0] : null;
}

// Função para inserir um novo item no estoque
Future<void> insereEstoqueSC(SupabaseClient supabase, Estoque estoque) async {
  try {
    await supabase.from('EstoqueSC').insert(estoque.toMap());
  } catch (e) {
    print(e.toString());
  }
}

// Função para atualizar a quantidade de um item no estoque
Future<void> atualizaEstoqueSC(SupabaseClient supabase, int frutaId,
    int produtorId, int embalagemId, double quantidade) async {
  try {
    await supabase.from('EstoqueSC').update({'Quantidade': quantidade}).match({
      'FrutaId': frutaId,
      'ProdutorId': produtorId,
      'EmbalagemId': embalagemId
    });
  } catch (e) {
    print('Erro ao atualizar quantidade:');
  }
}

// Função para lidar com uma entrada
Future<void> processaEntradaSC(SupabaseClient supabase, int frutaId,
    int produtorId, int embalagemId, double quantidade) async {
  Map<String, dynamic>? itemEstoque =
      await consultaEstoqueSC(supabase, frutaId, produtorId, embalagemId);

  if (itemEstoque != null) {
    // Se o item existir no estoque, atualiza a quantidade
    int quantidadeAntiga = itemEstoque['Quantidade'];
    double novaQuantidade = quantidadeAntiga + quantidade;
    await atualizaEstoqueSC(
        supabase, frutaId, produtorId, embalagemId, novaQuantidade);
  } else {
    // Se o item não existir no estoque, cria um novo registro

    await insereEstoqueSC(
        supabase,
        Estoque(
            id: 1,
            frutaId: frutaId,
            embalagemId: embalagemId,
            quantidade: quantidade,
            produtorId: produtorId));
  }
}
