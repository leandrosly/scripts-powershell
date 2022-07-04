# Instalação do GLPI Inventory Agent via GPO

# Repositorio oficial
# https://github.com/glpi-project/glpi-agent/releases

# Arquivo de instalação 64 bits:
$msi64 = "https://github.com/glpi-project/glpi-agent/releases/download/1.4/GLPI-Agent-1.4-x64.msi"

# Arquivo de instalação 32 bits:
$msi32 = "https://github.com/glpi-project/glpi-agent/releases/download/1.4/GLPI-Agent-1.4-x86.msi"

# Versão do instalador atualizado:
$versao = "1.4"

# Tag para selecionar entidade
$tag = "IPASSP"

# Endereço do servidor:
$servidor = "glpi.ipassp.intra"

####################################################

Function Instalar {

  if ([Environment]::Is64BitProcess) {

    Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i $msi64 SERVER=$servidor TAG=$tag RUNNOW=1 /qn"

  } else {

    msiexec /i $msi32 SERVER=$servidor TAG=$tag RUNNOW=1 /qn

  }

}

# Verificar se o fusion esta instalado e remover
if ((Get-Service -Name "*FusionInventory*" -ErrorAction SilentlyContinue) -ne $null) {

  echo "Remover servico do fusion"
  Stop-Service 'FusionInventory-Agent'; Get-CimInstance -ClassName Win32_Service -Filter "Name='FusionInventory-Agent'" | Remove-CimInstance

}

# Verifica se o agente glpi ja esta instalado
if ((Get-Service -Name "*glpi-agent*" -ErrorAction SilentlyContinue) -ne $null) {

  $match = 'This is GLPI Agent ' + $versao

  # Se a versao instalada nao for a atual, instalar a nova
  if ((Invoke-WebRequest -Uri "http://localhost:62354" -UseBasicParsing).Content -notmatch $match) {

    echo "Atualizar"
    Instalar

  } else {

    echo "ja instalado"

  }

} else {

  echo "Atualizar"
  Instalar

}
