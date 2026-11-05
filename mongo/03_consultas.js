// ============================================================================
// SPRINT 4 - CONSULTAS NO MONGODB
//   mongosh "mongodb://localhost:27017/vetly" --file 03_consultas.js
//
// Funciona com QUALQUER dataset exportado do Oracle (nada de ids ou nomes fixos):
// os valores usados nos filtros sao lidos da propria colecao. Cada consulta traz o
// equivalente relacional ao lado, para o video.
// ============================================================================

const total = db.animais.countDocuments();
print(`> vetly.animais: ${total} documento(s)`);
if (total === 0) {
  print('Colecao vazia: rode 02_importar_mongo.js antes.');
  quit(1);
}

const primeiro = db.animais.find().sort({ nome: 1 }).limit(1).toArray()[0];
// Animal com historico de consultas (se houver); senao usa o primeiro animal.
const comConsultas = db.animais.findOne({ 'consultas.0': { $exists: true } }, { nome: 1 });
const alvo = comConsultas || primeiro;

print(`\n1) Ficha do animal "${alvo.nome}" (1 leitura; no Oracle: 4 JOINs)`);
printjson(db.animais.findOne({ _id: alvo._id },
  { nome: 1, especie: 1, raca: 1, 'tutor.nome': 1, consultas: 1 }));

const idTutor = alvo.tutor && alvo.tutor.idTutor;
print(`\n2) Animais do tutor ${idTutor} (indice tutor.idTutor)`);
printjson(db.animais.find({ 'tutor.idTutor': idTutor }, { nome: 1, especie: 1 }).toArray());

print('\n3) Animais por especie (GROUP BY especie no Oracle)');
printjson(db.animais.aggregate([
  { $group: { _id: '$especie', animais: { $sum: 1 } } },
  { $sort: { _id: 1 } }
]).toArray());

const qtdConsultas = db.animais.aggregate([
  { $unwind: '$consultas' }, { $count: 'n' }
]).toArray();

if (qtdConsultas.length === 0) {
  print('\nO dataset nao possui consultas: as consultas 4 a 6 foram puladas.');
  print('(cadastre consultas no Oracle e exporte de novo com 01_exportar_dataset.sql)');
} else {
  print('\n4) Faturamento por veterinario e status (espelha PKG_VETLY_RELATORIO.prc_consultas_vet_status)');
  printjson(db.animais.aggregate([
    { $unwind: '$consultas' },
    { $group: {
        _id: { vet: '$consultas.veterinario.nome', status: '$consultas.status' },
        qtd: { $sum: 1 },
        total: { $sum: '$consultas.valor' } } },
    { $sort: { '_id.vet': 1, '_id.status': 1 } }
  ]).toArray());

  print('\n5) Total geral das consultas (confere com o TOTAL GERAL do relatorio Oracle)');
  printjson(db.animais.aggregate([
    { $unwind: '$consultas' },
    { $group: { _id: null, qtd: { $sum: 1 }, total: { $sum: '$consultas.valor' } } }
  ]).toArray());

  // Mes da consulta mais recente do proprio dataset (nao depende de data fixa).
  const ultima = db.animais.aggregate([
    { $unwind: '$consultas' },
    { $sort: { 'consultas.dataHora': -1 } },
    { $limit: 1 },
    { $project: { _id: 0, d: '$consultas.dataHora' } }
  ]).toArray()[0].d;
  const ini = new Date(Date.UTC(ultima.getUTCFullYear(), ultima.getUTCMonth(), 1));
  const fim = new Date(Date.UTC(ultima.getUTCFullYear(), ultima.getUTCMonth() + 1, 1));
  print(`\n6) Consultas de ${ini.toISOString().slice(0, 7)} (mes da consulta mais recente; indice consultas.dataHora)`);
  printjson(db.animais.aggregate([
    { $unwind: '$consultas' },
    { $match: { 'consultas.dataHora': { $gte: ini, $lt: fim } } },
    { $project: { _id: 0, animal: '$nome', data: '$consultas.dataHora',
                  status: '$consultas.status', vet: '$consultas.veterinario.nome' } }
  ]).toArray());
}
