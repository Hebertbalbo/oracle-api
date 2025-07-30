<?php
header('Content-Type: application/json');

// 🔐 Recupera token da variável de ambiente
$tokenEsperado = getenv('API_TOKEN') ?: '';

if (!isset($_GET['token']) || $_GET['token'] !== $tokenEsperado) {
    http_response_code(403);
    echo json_encode(['error' => 'Acesso não autorizado']);
    exit;
}

// ✅ Só permite SELECTs
$query = $_GET['q'] ?? '';
if (!$query || stripos(trim(strtolower($query)), 'select') !== 0) {
    echo json_encode(['error' => 'Somente SELECT permitido']);
    exit;
}

// 🔐 Credenciais via variáveis de ambiente
$usuario = getenv('DB_USER');
$senha = getenv('DB_PASS');
$connectString = getenv('DB_DSN');

// ⚠️ Verifica se credenciais estão configuradas
if (!$usuario || !$senha || !$connectString) {
    echo json_encode(['error' => 'Credenciais não configuradas corretamente']);
    exit;
}

// 🔌 Conecta ao Oracle
$conn = oci_connect($usuario, $senha, $connectString);
if (!$conn) {
    echo json_encode(['error' => oci_error()]);
    exit;
}

$stid = oci_parse($conn, $query);
oci_execute($stid);

$dados = [];
while (($row = oci_fetch_array($stid, OCI_ASSOC + OCI_RETURN_NULLS)) !== false) {
    $dados[] = $row;
}

oci_free_statement($stid);
oci_close($conn);

// ✅ Retorna os dados como JSON
echo json_encode($dados);

