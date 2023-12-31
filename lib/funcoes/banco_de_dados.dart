// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, empty_catches

import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';
import 'package:maca_ipe/datas/carga.dart';
import 'package:maca_ipe/datas/embalagem.dart';
import 'package:maca_ipe/datas/entradas.dart';
import 'package:maca_ipe/datas/estoque.dart';
import 'package:maca_ipe/datas/estoque_lista.dart';
import 'package:maca_ipe/datas/fruta.dart';
import 'package:maca_ipe/datas/palete.dart';
import 'package:maca_ipe/datas/palete_fruta.dart';
import 'package:maca_ipe/datas/produtor.dart';
import 'package:maca_ipe/datas/romaneio.dart';
import 'package:maca_ipe/datas/romaneio_cp.dart';
import 'package:maca_ipe/datas/romaneio_lista.dart';
import 'package:maca_ipe/datas/romaneio_m.dart';
import 'package:maca_ipe/datas/romaneio_o.dart';
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

Future<Map<String, dynamic>?> consultaEstoqueC(SupabaseClient supabase,
    int frutaId, String calibre, String categoria) async {
  final response = await supabase
      .from('EstoqueC')
      .select('*')
      .eq('FrutaId', frutaId)
      .eq('Calibre', calibre)
      .eq('Categoria', categoria);

  return response.length > 0 ? response[0] : null;
}

// Função para inserir um novo item no estoque
Future<void> insereEstoqueSC(SupabaseClient supabase, Estoque estoque) async {
  try {
    await supabase.from('EstoqueSC').insert(estoque.toMap());
  } catch (e) {}
}

Future<void> insereEstoqueC(SupabaseClient supabase, EstoqueC estoque) async {
  try {
    await supabase.from('EstoqueC').insert(estoque.toMap());
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

Future<void> atualizaEstoqueC(SupabaseClient supabase, int frutaId,
    double quantidade, String calibre, String categoria) async {
  try {
    await supabase.from('EstoqueC').update({'Quantidade': quantidade}).match({
      'FrutaId': frutaId,
      'Calibre': calibre,
      'Categoria': categoria,
    });
  } catch (e) {}
}

Future<void> deletaEstoqueC(SupabaseClient supabase, EstoqueC estoque) async {
  try {
    final response = await supabase
        .from('EstoqueC')
        .select('Quantidade, id')
        .eq('FrutaId', estoque.frutaId)
        .eq('Calibre', estoque.calibre)
        .eq('Categoria', estoque.categoria);

    int novaQuant = response[0]['Quantidade'] - estoque.quantidade;

    if (novaQuant > 0) {
      await atualizaEstoqueC(
          supabase,
          estoque.frutaId,
          double.parse(novaQuant.toString()),
          estoque.calibre,
          estoque.categoria);
    } else {
      await supabase.from('EstoqueC').delete().eq('id', response[0]['id']);
    }
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

//Função para lidar com EstoqueC
Future<void> processaEntradaEstoqueC(
    SupabaseClient client,
    Entradas entrada,
    BuildContext context,
    String nomeFruta,
    String calibre,
    String categoria) async {
  try {
    await client.from('Entradas').insert(entrada.toMap());

    Romaneio romaneio = Romaneio(
        id: 1,
        frutaId: entrada.frutaId,
        embalagemId: entrada.embalagemId,
        tFruta: 'RomaneioO',
        data: entrada.data,
        produtorId: entrada.produtorId);

    RomaneioO romaneioO = RomaneioO(
        id: 1,
        romaneioId: 1,
        nome: nomeFruta,
        quant: int.parse(entrada.quantidade.toString()));

    await cadastrarRomaneioO(
        client, romaneio, romaneioO, context, calibre, categoria);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Erro ao cadastrar",
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

// Função para lidar com o cadastro de novos romaneios de outros tipos de frutas
Future<void> cadastrarRomaneioO(
    SupabaseClient supabase,
    Romaneio romaneio,
    RomaneioO romaneioO,
    BuildContext context,
    String calibre,
    String categoria) async {
  try {
    final response =
        await supabase.from('Romaneio').insert(romaneio.toMap()).select('id');
    try {
      RomaneioO romaneiCad = RomaneioO(
        id: 1,
        romaneioId: response[0]['id'],
        nome: romaneioO.nome,
        quant: romaneioO.quant,
      );

      await supabase.from('RomaneioO').insert(romaneiCad.toMap());

      Map<String, dynamic>? itemEstoque = await consultaEstoqueC(
          supabase, romaneio.frutaId, calibre, categoria);

      if (itemEstoque != null) {
        // Se o item existir no estoque, atualiza a quantidade
        int quantidadeAntiga = itemEstoque['Quantidade'];
        int novaQuantidade = quantidadeAntiga + romaneioO.quant;
        await atualizaEstoqueC(supabase, romaneio.frutaId,
            double.parse(novaQuantidade.toString()), calibre, categoria);
      } else {
        // Se o item não existir no estoque, cria um novo registro

        await insereEstoqueC(
            supabase,
            EstoqueC(
              id: 1,
              frutaId: romaneio.frutaId,
              quantidade: romaneioO.quant,
              calibre: calibre,
              categoria: categoria,
            ));
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

      List<CalibreM> calibreM = parseCalibreMPRomaneio(romaneiCad);

      for (var element in calibreM) {
        if (element.cat1 > 0 && element.calibre != 'Total') {
          Map<String, dynamic>? itemEstoque = await consultaEstoqueC(
              supabase, romaneio.frutaId, element.calibre, 'Cat1');

          if (itemEstoque != null) {
            // Se o item existir no estoque, atualiza a quantidade
            int quantidadeAntiga = itemEstoque['Quantidade'];
            int novaQuantidade = quantidadeAntiga + element.cat1;
            await atualizaEstoqueC(
                supabase,
                romaneio.frutaId,
                double.parse(novaQuantidade.toString()),
                element.calibre,
                'Cat1');
          } else {
            // Se o item não existir no estoque, cria um novo registro

            await insereEstoqueC(
                supabase,
                EstoqueC(
                  id: 1,
                  frutaId: romaneio.frutaId,
                  quantidade: element.cat1,
                  calibre: element.calibre,
                  categoria: 'Cat1',
                ));
          }
        }
        if (element.cat2 > 0 && element.calibre != 'Total') {
          Map<String, dynamic>? itemEstoque = await consultaEstoqueC(
              supabase, romaneio.frutaId, element.calibre, 'Cat2');

          if (itemEstoque != null) {
            // Se o item existir no estoque, atualiza a quantidade
            int quantidadeAntiga = itemEstoque['Quantidade'];
            int novaQuantidade = quantidadeAntiga + element.cat2;
            await atualizaEstoqueC(
                supabase,
                romaneio.frutaId,
                double.parse(novaQuantidade.toString()),
                element.calibre,
                'Cat2');
          } else {
            // Se o item não existir no estoque, cria um novo registro

            await insereEstoqueC(
                supabase,
                EstoqueC(
                  id: 1,
                  frutaId: romaneio.frutaId,
                  quantidade: element.cat2,
                  calibre: element.calibre,
                  categoria: 'Cat2',
                ));
          }
        }
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

      List<CalibreCp> calibreCp = parseCalibrePaPRomaneio(romaneiCad);

      for (var element in calibreCp) {
        if (element.quant > 0 && element.calibre != 'Total') {
          Map<String, dynamic>? itemEstoque = await consultaEstoqueC(
              supabase, romaneio.frutaId, element.calibre, "1");

          if (itemEstoque != null) {
            // Se o item existir no estoque, atualiza a quantidade
            int quantidadeAntiga = itemEstoque['Quantidade'];
            int novaQuantidade = quantidadeAntiga + element.quant;
            await atualizaEstoqueC(supabase, romaneio.frutaId,
                double.parse(novaQuantidade.toString()), element.calibre, '1');
          } else {
            // Se o item não existir no estoque, cria um novo registro

            await insereEstoqueC(
                supabase,
                EstoqueC(
                  id: 1,
                  frutaId: romaneio.frutaId,
                  quantidade: element.quant,
                  calibre: element.calibre,
                  categoria: '1',
                ));
          }
        }
      }
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

      List<CalibreCp> calibreCp = parseCalibreCpPRomaneio(romaneiCad);

      for (var element in calibreCp) {
        if (element.quant > 0 && element.calibre != 'Total') {
          Map<String, dynamic>? itemEstoque = await consultaEstoqueC(
              supabase, romaneio.frutaId, element.calibre, "1");

          if (itemEstoque != null) {
            // Se o item existir no estoque, atualiza a quantidade
            int quantidadeAntiga = itemEstoque['Quantidade'];
            int novaQuantidade = quantidadeAntiga + element.quant;
            await atualizaEstoqueC(supabase, romaneio.frutaId,
                double.parse(novaQuantidade.toString()), element.calibre, '1');
          } else {
            // Se o item não existir no estoque, cria um novo registro

            await insereEstoqueC(
                supabase,
                EstoqueC(
                  id: 1,
                  frutaId: romaneio.frutaId,
                  quantidade: element.quant,
                  calibre: element.calibre,
                  categoria: '1',
                ));
          }
        }
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
  if (fruta.isEmpty) {
    return fetchFrutasPadra(client);
  } else {
    final frutasJson = await client
        .from("Fruta")
        .select()
        .or('Nome.eq.$fruta,Nome.eq.$fruta2')
        .order('Nome', ascending: true)
        .order('Variedade', ascending: true);
    return parseFrutas(frutasJson);
  }
}

Future<List<Fruta>> fetchFrutasPadra(SupabaseClient client) async {
  final frutasJson = await client
      .from("Fruta")
      .select()
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

//Buscando paletes
Future<List<Palete>> buscarPaletesNCarregados(
    SupabaseClient client, bool carregado) async {
  final paleteJson = await client
      .from('Palete')
      .select()
      .eq('Carregado', carregado)
      .order('Data', ascending: true);
  return parsePaleteJson(paleteJson);
}

Future<List<Palete>> buscarPaletes(
  SupabaseClient client,
) async {
  final paleteJson =
      await client.from('Palete').select().order('Data', ascending: true);
  return parsePaleteJson(paleteJson);
}

Future<List<Palete>> buscarPaleteId(SupabaseClient client, int id) async {
  final List<dynamic> paleteJson =
      await client.from('Palete').select().eq('id', id);
  return paleteJson.map((e) => Palete.fromJson(e)).toList();
}

Future<List<Palete>> buscarPaletesPelaCarga(
    SupabaseClient client, int carga) async {
  final paleteJson = await client.from('Palete').select().eq('CargaId', carga);
  return parsePaleteJson(paleteJson);
}

List<Palete> parsePaleteJson(List<dynamic> responseBody) {
  List<Palete> palete = responseBody.map((e) => Palete.fromJson(e)).toList();
  return palete;
}

Future<List<PaleteFrutaLista>> buscarPaleteFruta(
    SupabaseClient client, int paleteId) async {
  final paleteJson = await client
      .from('Palete_Fruta')
      .select(
          'id, Fruta(id, Nome, Variedade), PaleteId, Quantidade, Calibre, Categoria')
      .eq('PaleteId', paleteId);
  return parsePaleteFrutaJson(paleteJson);
}

List<PaleteFrutaLista> parsePaleteFrutaJson(List<dynamic> responseBody) {
  List<PaleteFrutaLista> paleteF =
      responseBody.map((e) => PaleteFrutaLista.fromJson(e)).toList();
  return paleteF;
}

Future<List<PaleteFrutaLista>> buscaPaleteFrutaPCarga(
    SupabaseClient client, int carga) async {
  List<Palete> paletes = await buscarPaletesPelaCarga(client, carga);
  List<PaleteFrutaLista> listaDefinit = [];
  List<PaleteFrutaLista> listaAux = [];

  for (var element in paletes) {
    final paleteJson = await client
        .from('Palete_Fruta')
        .select(
            'id, Fruta(id, Nome, Variedade), PaleteId, Quantidade, Calibre, Categoria')
        .eq('PaleteId', element.id);
    listaAux = parsePaleteFrutaJson(paleteJson);
    for (var ele in listaAux) {
      int auxNum = 0;
      for (var i = 0; i < listaDefinit.length; i++) {
        if (ele.calibre == listaDefinit[i].calibre &&
            ele.categoria == listaDefinit[i].categoria &&
            ele.fruta.nome == listaDefinit[i].fruta.nome &&
            ele.fruta.variedade == listaDefinit[i].fruta.variedade) {
          listaDefinit[i].quantidade += ele.quantidade;
          auxNum = 1;
        }
      }
      if (auxNum == 0) {
        listaDefinit.add(ele);
      }
    }
  }

  listaDefinit.sort((a, b) {
    var adate = a.calibre;
    var bdate = b.calibre;
    return adate.compareTo(bdate);
  });

  return listaDefinit;
}

Future<Map<String, double>> buscarPaletesPChart(SupabaseClient client, {bool carregado = false}) async {
  var mapObj = <String, double>{};

  List<Palete> paletes = await buscarPaletesNCarregados(client, carregado);

  for (var ele in paletes) {
    List<PaleteFrutaLista> aux = await buscarPaleteFruta(client, ele.id);
    List<PaleteFrutaLista> paleteFruta = [];
    for (var e in aux) {
      if (paleteFruta.isEmpty) {
        paleteFruta.add(e);
      } else if (paleteFruta[0].quantidade < e.quantidade) {
        paleteFruta.clear();
        paleteFruta.add(e);
      }
    }
    if (mapObj[paleteFruta[0].fruta.nome] == null) {
      mapObj[paleteFruta[0].fruta.nome] = 1;
    } else {
      mapObj[paleteFruta[0].fruta.nome] =
          1 + mapObj[paleteFruta[0].fruta.nome]!;
    }
  }

  return mapObj;
}

Future<void> createPalete(SupabaseClient client, List<EstoqueC> estoquec,
    Palete palete, BuildContext context) async {
  try {
    final response =
        await client.from('Palete').insert(palete.toMap()).select('id');

    for (var ele in estoquec) {
      await cadPaleteFruta(
          client,
          PaleteFruta(
              id: 1,
              frutaId: ele.frutaId,
              paleteId: response[0]['id'],
              quantidade: ele.quantidade,
              calibre: ele.calibre,
              categoria: ele.categoria),
          context);

      await deletaEstoqueC(client, ele);
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

Future<void> cadPaleteFruta(SupabaseClient client, PaleteFruta paleteFruta,
    BuildContext context) async {
  try {
    await client.from('Palete_Fruta').insert(paleteFruta.toMap());
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

//Buscando cargas
Future<List<Carga>> buscarCargas(SupabaseClient client) async {
  final cargaJson = await client.from('Carga').select().order('Data');
  return parseCargaJson(cargaJson);
}

List<Carga> parseCargaJson(List<dynamic> responseBody) {
  List<Carga> carga = responseBody.map((e) => Carga.fromJson(e)).toList();
  return carga;
}

//Consulta de estoque
Future<List<EstoqueLista>> buscarEstoque(
    SupabaseClient client, String tabela) async {
  final estoqueJson = await client
      .from(tabela)
      .select(
          'id, Fruta:FrutaId(id, Nome, Variedade), Embalagem(id, Nome), Quantidade, Produtor(id, Nome, Sobrenome)')
      .order('Quantidade');

  return parseEstoque(estoqueJson);
}

List<EstoqueLista> parseEstoque(List<dynamic> responseBody) {
  List<EstoqueLista> estoque =
      responseBody.map((e) => EstoqueLista.fromJson(e)).toList();
  return estoque;
}

Future<List<EstoqueListaC>> buscarEstoqueC(SupabaseClient client) async {
  final estoqueJson = await client
      .from('EstoqueC')
      .select(
          'id, Fruta:FrutaId(id, Nome, Variedade), Quantidade, Calibre, Categoria')
      .order('Quantidade');

  return parseEstoqueC(estoqueJson);
}

List<EstoqueListaC> parseEstoqueC(List<dynamic> responseBody) {
  List<EstoqueListaC> estoque =
      responseBody.map((e) => EstoqueListaC.fromJson(e)).toList();
  return estoque;
}

//Busca Produtores
Future<List<Produtor>> buscarProdutores(SupabaseClient client) async {
  final produtoresJson =
      await client.from('Produtor').select().order('Nome').order('Sobrenome');

  return parseProdutores(produtoresJson);
}

List<Produtor> parseProdutores(List<dynamic> responseBody) {
  List<Produtor> produtores =
      responseBody.map((e) => Produtor.fromJson(e)).toList();
  return produtores;
}

//Buscar Romaneio Lista

Future<List<RomaneioLista>> buscarRomaneioLista(SupabaseClient client) async {
  final romaneioJson = await client
      .from('Romaneio')
      .select(
          'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Data, Produtor(id, Nome, Sobrenome), TFruta')
      .order('Data');

  return parseRomaneioJson(romaneioJson);
}

List<RomaneioLista> parseRomaneioJson(List<dynamic> responseBody) {
  List<RomaneioLista> romaneio =
      responseBody.map((e) => RomaneioLista.fromJson(e)).toList();
  return romaneio;
}

//Busca romaneio lista por produtor
Future<List<RomaneioLista>> buscarRomaneioListaProdutor(
    SupabaseClient client, int id) async {
  final romaneioJson = await client
      .from('Romaneio')
      .select(
          'id, Fruta(id, Nome, Variedade), Embalagem(id, Nome), Data, Produtor(id, Nome, Sobrenome), TFruta')
      .eq('ProdutorId', id)
      .order('Data');

  return parseRomaneioJson(romaneioJson);
}

//recebendo dados para romaneio M
Future<List<RomaneioM>> buscarRomaneioM(SupabaseClient client, int id) async {
  final romaneioMJson =
      await client.from('RomaneioM').select().eq('RomaneioId', id);

  return parseRomaneioMJson(romaneioMJson);
}

List<RomaneioM> parseRomaneioMJson(List<dynamic> responseBody) {
  List<RomaneioM> romaneioM =
      responseBody.map((e) => RomaneioM.fromJson(e)).toList();
  return romaneioM;
}

List<CalibreM> parseCalibreMPRomaneio(RomaneioM r) {
  List<CalibreM> calibrem = [
    CalibreM(calibre: '220', cat1: r.c2201, cat2: 0),
    CalibreM(calibre: '198', cat1: r.c1981, cat2: 0),
    CalibreM(calibre: '180', cat1: r.c1801, cat2: r.c1802),
    CalibreM(calibre: '165', cat1: r.c1651, cat2: r.c1652),
    CalibreM(calibre: '150', cat1: r.c1501, cat2: r.c1502),
    CalibreM(calibre: '135', cat1: r.c1351, cat2: r.c1352),
    CalibreM(calibre: '120', cat1: r.c1201, cat2: r.c1202),
    CalibreM(calibre: '110', cat1: r.c1101, cat2: r.c1102),
    CalibreM(calibre: '100', cat1: r.c1001, cat2: r.c1002),
    CalibreM(calibre: '90', cat1: r.c901, cat2: r.c902),
    CalibreM(calibre: '80', cat1: r.c801, cat2: r.c802),
    CalibreM(calibre: '70', cat1: r.c701, cat2: r.c702),
    CalibreM(calibre: 'Comercial', cat1: 0, cat2: r.comercial),
    CalibreM(
        calibre: 'Total',
        cat1: r.c2201 +
            r.c1981 +
            r.c1801 +
            r.c1651 +
            r.c1501 +
            r.c1351 +
            r.c1201 +
            r.c1101 +
            r.c1001 +
            r.c901 +
            r.c801 +
            r.c701,
        cat2: r.c1802 +
            r.c1652 +
            r.c1502 +
            r.c1352 +
            r.c1202 +
            r.c1102 +
            r.c1002 +
            r.c902 +
            r.c802 +
            r.c702 +
            r.comercial),
  ];
  return calibrem;
}

List<List<CalibreM>> addTotaisCalibreM(List<List<CalibreM>> calibresGerais) {
  List<int> totaisc1 = List.generate(14, (_) => 0);

  List<int> totaisc2 = List.generate(14, (_) => 0);

  for (var ele in calibresGerais) {
    for (var i = 0; i < ele.length; i++) {
      totaisc1[i] += ele[i].cat1;
      totaisc2[i] += ele[i].cat2;
    }
  }
  List<CalibreM> calibreM = [
    CalibreM(
      calibre: '220',
      cat1: totaisc1[0],
      cat2: totaisc2[0],
    ),
    CalibreM(
      calibre: '198',
      cat1: totaisc1[1],
      cat2: totaisc2[1],
    ),
    CalibreM(
      calibre: '180',
      cat1: totaisc1[2],
      cat2: totaisc2[2],
    ),
    CalibreM(
      calibre: '165',
      cat1: totaisc1[3],
      cat2: totaisc2[3],
    ),
    CalibreM(
      calibre: '150',
      cat1: totaisc1[4],
      cat2: totaisc2[4],
    ),
    CalibreM(
      calibre: '135',
      cat1: totaisc1[5],
      cat2: totaisc2[5],
    ),
    CalibreM(
      calibre: '120',
      cat1: totaisc1[6],
      cat2: totaisc2[6],
    ),
    CalibreM(
      calibre: '110',
      cat1: totaisc1[7],
      cat2: totaisc2[7],
    ),
    CalibreM(
      calibre: '100',
      cat1: totaisc1[8],
      cat2: totaisc2[8],
    ),
    CalibreM(
      calibre: '90',
      cat1: totaisc1[9],
      cat2: totaisc2[9],
    ),
    CalibreM(
      calibre: '80',
      cat1: totaisc1[10],
      cat2: totaisc2[10],
    ),
    CalibreM(
      calibre: '70',
      cat1: totaisc1[11],
      cat2: totaisc2[11],
    ),
    CalibreM(calibre: 'Comercial', cat1: totaisc1[12], cat2: totaisc2[12]),
    CalibreM(
      calibre: 'Total',
      cat1: totaisc1[13],
      cat2: totaisc2[13],
    ),
  ];

  calibresGerais.add(calibreM);

  return calibresGerais;
}

//recebendo dados para romaneio CP

Future<List<RomaneioCp>> buscarRomaneioCp(SupabaseClient client, int id) async {
  final romaneioCpJson =
      await client.from('RomaneioCP').select().eq('RomaneioId', id);

  return parseRomaneioCpJson(romaneioCpJson);
}

List<RomaneioCp> parseRomaneioCpJson(List<dynamic> responseBody) {
  List<RomaneioCp> romaneioCp =
      responseBody.map((e) => RomaneioCp.fromJson(e)).toList();
  return romaneioCp;
}

List<CalibreCp> parseCalibreCpPRomaneio(RomaneioCp rcp) {
  List<CalibreCp> calibrecp = [
    CalibreCp(calibre: 'GG', quant: rcp.gg),
    CalibreCp(calibre: 'G', quant: rcp.g),
    CalibreCp(calibre: 'M', quant: rcp.m),
    CalibreCp(calibre: 'P', quant: rcp.p),
    CalibreCp(calibre: 'PP', quant: rcp.pp),
    CalibreCp(calibre: 'Cat 2', quant: rcp.cat2),
    CalibreCp(
        calibre: 'Total',
        quant: rcp.gg + rcp.g + rcp.m + rcp.p + rcp.pp + rcp.cat2),
  ];
  return calibrecp;
}

List<List<CalibreCp>> addTotaisCalibreCP(List<List<CalibreCp>> calibresGerais) {
  List<int> totais = List.generate(9, (_) => 0);

  for (var ele in calibresGerais) {
    for (var i = 0; i < ele.length; i++) {
      totais[i] += ele[i].quant;
    }
  }

  List<CalibreCp> calibreCP = [
    CalibreCp(calibre: 'GG', quant: totais[0]),
    CalibreCp(calibre: 'G', quant: totais[1]),
    CalibreCp(calibre: 'M', quant: totais[2]),
    CalibreCp(calibre: 'P', quant: totais[3]),
    CalibreCp(calibre: 'PP', quant: totais[4]),
    CalibreCp(calibre: 'Cat 2', quant: totais[5]),
    CalibreCp(calibre: 'Total', quant: totais[6]),
  ];

  calibresGerais.add(calibreCP);

  return calibresGerais;
}

//recebendo dados para romaneio PA

Future<List<RomaneioPa>> buscarRomaneioPa(SupabaseClient client, int id) async {
  final romaneioPaJson =
      await client.from('RomaneioPA').select().eq('RomaneioId', id);

  return parseRomaneioPaJson(romaneioPaJson);
}

List<RomaneioPa> parseRomaneioPaJson(List<dynamic> responseBody) {
  List<RomaneioPa> romaneioPa =
      responseBody.map((e) => RomaneioPa.fromJson(e)).toList();
  return romaneioPa;
}

List<CalibreCp> parseCalibrePaPRomaneio(RomaneioPa rpa) {
  List<CalibreCp> calibrecp = [
    CalibreCp(calibre: '45', quant: rpa.c45),
    CalibreCp(calibre: '40', quant: rpa.c40),
    CalibreCp(calibre: '36', quant: rpa.c36),
    CalibreCp(calibre: '32', quant: rpa.c32),
    CalibreCp(calibre: '30', quant: rpa.c30),
    CalibreCp(calibre: '28', quant: rpa.c28),
    CalibreCp(calibre: '24', quant: rpa.c24),
    CalibreCp(calibre: '22', quant: rpa.c22),
    CalibreCp(calibre: '20', quant: rpa.c20),
    CalibreCp(calibre: '18', quant: rpa.c18),
    CalibreCp(calibre: '14', quant: rpa.c14),
    CalibreCp(calibre: '12', quant: rpa.c12),
    CalibreCp(calibre: 'Cat 2', quant: rpa.cat2),
    CalibreCp(
        calibre: 'Total',
        quant: rpa.c45 +
            rpa.c40 +
            rpa.c36 +
            rpa.c32 +
            rpa.c30 +
            rpa.c28 +
            rpa.c24 +
            rpa.c22 +
            rpa.c20 +
            rpa.c18 +
            rpa.c14 +
            rpa.c12 +
            rpa.cat2),
  ];
  return calibrecp;
}

List<List<CalibreCp>> addTotaisCalibrePA(List<List<CalibreCp>> calibresGerais) {
  List<int> totais = List.generate(15, (_) => 0);

  for (var ele in calibresGerais) {
    for (var i = 0; i < ele.length; i++) {
      totais[i] += ele[i].quant;
    }
  }

  List<CalibreCp> calibreCP = [
    CalibreCp(calibre: '45', quant: totais[0]),
    CalibreCp(calibre: '40', quant: totais[1]),
    CalibreCp(calibre: '36', quant: totais[2]),
    CalibreCp(calibre: '32', quant: totais[3]),
    CalibreCp(calibre: '30', quant: totais[4]),
    CalibreCp(calibre: '28', quant: totais[5]),
    CalibreCp(calibre: '24', quant: totais[6]),
    CalibreCp(calibre: '22', quant: totais[7]),
    CalibreCp(calibre: '20', quant: totais[8]),
    CalibreCp(calibre: '18', quant: totais[9]),
    CalibreCp(calibre: '14', quant: totais[10]),
    CalibreCp(calibre: '12', quant: totais[11]),
    CalibreCp(calibre: 'Cat 2', quant: totais[12]),
    CalibreCp(calibre: 'Total', quant: totais[13]),
  ];

  calibresGerais.add(calibreCP);

  return calibresGerais;
}

//recebendo dados para romaneio O

Future<List<RomaneioO>> buscarRomaneioO(SupabaseClient client, int id) async {
  final romaneioOJson =
      await client.from('RomaneioO').select().eq('RomaneioId', id);

  return parseRomaneioOJson(romaneioOJson);
}

List<RomaneioO> parseRomaneioOJson(List<dynamic> responseBody) {
  List<RomaneioO> romaneioO =
      responseBody.map((e) => RomaneioO.fromJson(e)).toList();
  return romaneioO;
}