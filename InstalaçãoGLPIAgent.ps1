# Instalação do GLPI Inventory Agent via GPO

# Repositorio oficial
# https://github.com/glpi-project/glpi-agent/releases

# Arquivo de instalação 64 bits:
$msi64 = "https://github.com/glpi-project/glpi-agent/releases/download/1.3/GLPI-Agent-1.3-x64.msi"

# Arquivo de instalação 32 bits:
$msi32 = "https://github.com/glpi-project/glpi-agent/releases/download/1.3/GLPI-Agent-1.3-x86.msi"

# Versão do instalador atualizado:
$versao = "1.3"
$match = 'This is GLPI Agent ' + $versao

Function Instalar {

  if ([Environment]::Is64BitProcess) {

    msiexec /i $msi64 SERVER=glpi.ipassp.intra /qn

  } else {

    msiexec /i $msi32 SERVER=glpi.ipassp.intra /qn

  }

}

# Verificar se o fusion esta instalado e remover
if ((Get-Service -Name "*FusionInventory*" -ErrorAction SilentlyContinue) -ne $null) {

  Stop-Service 'FusionInventory-Agent'; Get-CimInstance -ClassName Win32_Service -Filter "Name='FusionInventory-Agent'" | Remove-CimInstance

}

# Verifica se o agente glpi ja esta instalado
if ((Get-Service -Name "*glpi-agent*" -ErrorAction SilentlyContinue) -ne $null) {

  # Se a versao instalada nao for a atual, instalar a nova
  if ((Invoke-WebRequest -Uri "http://localhost:62354" -UseBasicParsing).Content -notmatch $match) {

    Instalar

  } else {

    echo "ja instalado"

  }

} else {

  Instalar

}