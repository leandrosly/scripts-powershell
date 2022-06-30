# Instalação do Zabbix Agent 2 via GPO

# Repositorio oficial
# https://cdn.zabbix.com/zabbix/binaries/stable/6.0/

# Arquivo de instalação 64 bits:
$msi64="https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.5/zabbix_agent2-6.0.5-windows-amd64-openssl.msi"

# Arquivo de instalação 32 bits:
$msi32="https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.5/zabbix_agent2-6.0.5-windows-i386-openssl.msi"

# Versão do instalador atualizado:
$versao="6.0.5"

# Endereço do servidor:
$servidor = "zabbix.ipassp.intra"

# One liner 64b
# Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i `"https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.5/zabbix_agent2-6.0.5-windows-amd64-openssl.msi`" HOSTNAME=`"RPPS`" ACTIVE=`"`" SERVER=`"zabbix.ipassp.intra`" /qn"

################################################

Function Instalar {

  $nome = ([Environment]::MachineName)

  if ([Environment]::Is64BitProcess) {

    Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i $msi64 HOSTNAME=$nome ACTIVE=`"`" SERVER=$servidor /qn"

  } else {

    Start-Process -Wait -FilePath "msiexec" -ArgumentList "/i $msi32 HOSTNAME=$nome ACTIVE=`"`" SERVER=$servidor /qn"

  }

}

# Verifica se o agente ja esta instalado
if ((Get-Service -Name "zabbix agent*" -ErrorAction SilentlyContinue) -ne $null) {

  # Verifica a versao instalada
  if ((& 'C:\Program Files\Zabbix Agent 2\zabbix_agent2.exe' -V).Split([Environment]::NewLine)[0] -replace '^.* (\d+(\.\d+){2})$', '$1' -ne $versao) {

    echo "Atualizar"
    Instalar

  } else {

  echo "Ja instalado"

}

} else {

  echo "Instalar"
  Instalar

}