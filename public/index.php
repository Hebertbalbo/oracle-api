<?php
header('Content-Type: application/json');

$tokenEsperado = 'mywdaj-banQih-3dowjo';

if (!isset($_GET['token']) || $_GET['token'] !== $tokenEsperado) {
    http_response_code(403);
    echo json_encode(['error' => 'Acesso não autorizado']);
    exit;
}

$query = $_GET['q'] ?? '';
if (!$query || stripos(trim(strtolower($query)), 'select') !== 0) {
    echo json_encode(['error' => 'Somente SELECT permitido']);
    exit;
}

$usuario = 'AMORIX20';
$senha = '@291#amorix';
$connectString = 'amorix.ddns.com.br:1521/PROD';

$conn = oci_connect($usuario, $senha, $connectString);
if (!$conn) {
    echo json_encode(['error' => oci_error()]);
    exit;
}

$stid = oci_parse($conn, $query);
oci_execute($stid);

$dados = [];
while (($row = oci_fetch_array($stid, OCI_ASSOC + OCI_RETURN_NULLS)) != false) {
    $dados[] = $row;
}

oci_free_statement($stid);
oci_close($conn);

// ✅ Adicione esta linha para retornar os dados
echo json_encode($dados);
