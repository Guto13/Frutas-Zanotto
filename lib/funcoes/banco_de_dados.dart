// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, empty_catches

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/estoque.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_cp.dart';
import 'package:maca_ipe/datas/palete_m.dart';
import 'package:maca_ipe/datas/palete_o.dart';
import 'package:maca_ipe/datas/palete_pa.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/romaneio_pa.dart';
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
  } catch (e) {}
}

// Função para atualizar a quantidade de um item no estoque
Future<void> atualizaEstoqueSCPorID(
    SupabaseClient supabase, int id, double quantidade) async {
  try {
    await supabase
        .from('EstoqueSC')
        .update({'Quantidade': quantidade}).match({'id': id});
  } catch (e) {}
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
  } catch (e) {}
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

// Função para lidar com a exclusão de uma entrada
Future<void> excluirEntradaSC(
    SupabaseClient supabase,
    int frutaId,
    int produtorId,
    int embalagemId,
    double quantidade,
    int id,
    BuildContext context) async {
  Map<String, dynamic>? itemEstoque =
      await consultaEstoqueSC(supabase, frutaId, produtorId, embalagemId);

  int quantidadeAntiga = itemEstoque!['Quantidade'];
  double novaQuantidade = quantidadeAntiga - quantidade;
  if (novaQuantidade >= 0) {
    await atualizaEstoqueSC(
        supabase, frutaId, produtorId, embalagemId, novaQuantidade);

    await supabase.from('Entradas').delete().eq('id', id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Entrada excluida com sucesso",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Estoque negativo, impossível excluir a entrada",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

// Função para lidar com a exclusão de uma classificação
Future<void> excluirClassifi(
    SupabaseClient supabase,
    int frutaId,
    int produtorId,
    int embalagemId,
    double quantidade,
    int id,
    BuildContext context) async {
  Map<String, dynamic>? itemEstoque =
      await consultaEstoqueSC(supabase, frutaId, produtorId, embalagemId);

  int quantidadeAntiga = itemEstoque!['Quantidade'];
  double novaQuantidade = quantidadeAntiga + quantidade;

  await atualizaEstoqueSC(
      supabase, frutaId, produtorId, embalagemId, novaQuantidade);

  await supabase.from('Classificacao').delete().eq('id', id);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        "Classificação excluida com sucesso",
        style: TextStyle(color: textColor),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
}

// Função para lidar com o cadastro de novos romaneios de maçã
Future<void> cadastrarRomaneioM(SupabaseClient supabase, Romaneio romaneio,
    RomaneioM romaneioM, BuildContext context) async {
  try {
    final response =
        await supabase.from('Romaneio').insert(romaneio.toMap()).select('id');
    try {
      RomaneioM romaneiCad = RomaneioM(
          id: 1,
          romaneioId: response[0]['id'],
          c2201: romaneioM.c2201,
          c1981: romaneioM.c1981,
          c1801: romaneioM.c1801,
          c1651: romaneioM.c1651,
          c1501: romaneioM.c1501,
          c1351: romaneioM.c1351,
          c1201: romaneioM.c1201,
          c1101: romaneioM.c1101,
          c1001: romaneioM.c1001,
          c901: romaneioM.c901,
          c801: romaneioM.c801,
          c701: romaneioM.c701,
          c1802: romaneioM.c1802,
          c1652: romaneioM.c1652,
          c1502: romaneioM.c1502,
          c1352: romaneioM.c1352,
          c1202: romaneioM.c1202,
          c1102: romaneioM.c1102,
          c1002: romaneioM.c1002,
          c902: romaneioM.c902,
          c802: romaneioM.c802,
          c702: romaneioM.c702,
          comercial: romaneioM.comercial);

      await supabase.from('RomaneioM').insert(romaneiCad.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

// Função para lidar com o cadastro de novos romaneios de Pêssego e Ameixa
Future<void> cadastrarRomaneioPA(SupabaseClient supabase, Romaneio romaneio,
    RomaneioPa romaneioPa, BuildContext context) async {
  try {
    final response =
        await supabase.from('Romaneio').insert(romaneio.toMap()).select('id');
    try {
      RomaneioPa romaneiCad = RomaneioPa(
          id: 1,
          romaneioId: response[0]['id'],
          c45: romaneioPa.c45,
          c40: romaneioPa.c40,
          c36: romaneioPa.c36,
          c32: romaneioPa.c32,
          c30: romaneioPa.c30,
          c28: romaneioPa.c28,
          c24: romaneioPa.c24,
          c22: romaneioPa.c22,
          c20: romaneioPa.c20,
          c18: romaneioPa.c18,
          c14: romaneioPa.c14,
          c12: romaneioPa.c12,
          cat2: romaneioPa.cat2);

      await supabase.from('RomaneioPA').insert(romaneiCad.toMap());
    } catch (e) {
      //print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

// Função para lidar com o cadastro de novos romaneios de Pêssego e Ameixa
Future<void> cadastrarRomaneioCP(SupabaseClient supabase, Romaneio romaneio,
    RomaneioCp romaneioCp, BuildContext context) async {
  try {
    final response =
        await supabase.from('Romaneio').insert(romaneio.toMap()).select('id');
    try {
      RomaneioCp romaneiCad = RomaneioCp(
          id: 1,
          romaneioId: response[0]['id'],
          gg: romaneioCp.gg,
          g: romaneioCp.g,
          m: romaneioCp.m,
          p: romaneioCp.p,
          pp: romaneioCp.pp,
          cat2: romaneioCp.cat2);

      await supabase.from('RomaneioCP').insert(romaneiCad.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: textColor),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

//Ajustando Frutas, Produtores e Embalagens para listar
Future<List<Fruta>> fetchFrutas(
    SupabaseClient client, String fruta, String fruta2) async {
  final frutasJson = await client
      .from("Fruta")
      .select()
      .or('Nome.eq.$fruta,Nome.eq.$fruta2')
      .order('Nome', ascending: true)
      .order('Variedade', ascending: true);
  return parseFrutas(frutasJson);
}

Future<List<Produtor>> fetchProdutores(SupabaseClient client) async {
  final produtoresJson = await client
      .from("Produtor")
      .select()
      .order('Nome', ascending: true)
      .order('Sobrenome', ascending: true);
  return parseProdutor(produtoresJson);
}

Future<List<Embalagem>> fetchEmbalagens(SupabaseClient client) async {
  final embalagensJson =
      await client.from("Embalagem").select().order('Nome', ascending: true);
  return parseEmbalagem(embalagensJson);
}

List<Embalagem> parseEmbalagem(List<dynamic> responseBody) {
  List<Embalagem> embalagemList =
      responseBody.map((item) => Embalagem.fromJson(item)).toList();
  return embalagemList;
}

List<Fruta> parseFrutas(List<dynamic> responseBody) {
  List<Fruta> frutasList =
      responseBody.map((item) => Fruta.fromJson(item)).toList();
  return frutasList;
}

List<Produtor> parseProdutor(List<dynamic> responseBody) {
  List<Produtor> produtorList =
      responseBody.map((item) => Produtor.fromJson(item)).toList();
  return produtorList;
}

//Cadastro novos paletes
Future<void> cadastroPaleteM(
    SupabaseClient supabase, PaleteM palete, BuildContext context) async {
  try {
    await supabase.from('PaleteM').insert(palete.toMap());
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

Future<void> cadastroPaleteCP(
    SupabaseClient supabase, PaleteCP palete, BuildContext context) async {
  try {
    await supabase.from('PaleteCP').insert(palete.toMap());
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

Future<void> cadastroPaletePA(
    SupabaseClient supabase, PaletePA palete, BuildContext context) async {
  try {
    await supabase.from('PaletePA').insert(palete.toMap());
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

Future<void> cadastroPaleteO(
    SupabaseClient supabase, PaleteO palete, BuildContext context) async {
  try {
    await supabase.from('PaleteO').insert(palete.toMap());
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: textColor),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

//Buscando paletes
Future<List<Palete>> buscarPaletes(SupabaseClient client) async {
  final paleteJson = await client.from('Palete').select().order('Data');
  return parsePaleteJson(paleteJson);
}

List<Palete> parsePaleteJson(List<dynamic> responseBody) {
  List<Palete> palete = responseBody.map((e) => Palete.fromJson(e)).toList();
  return palete;
}


//Buscando cargas
Future<List<Carga>> buscarCargas(SupabaseClient client) async {
  final cargaJson = await client.from('Carga').select().order('Data');
  return parseCargaJson(cargaJson);
}

List<Carga> parseCargaJson(List<dynamic> responseBody) {
  List<Carga> carga = responseBody.map((e) => Carga.fromJson(e)).toList();
  return carga;
}
