# Instalação do Hardware Supervisor via GPO

# Repositorio oficial
# https://github.com/darkbrain-fc/HardwareSupervisor/releases/

# Arquivo de instalação 64 bits:
$msi = "https://github.com/darkbrain-fc/HardwareSupervisor/releases/download/0.3.1/HardwareSupervisorSetup.msi"

# Versão do instalador atualizado:
#$versao = "0.3.1"

####################################################

Function Instalar {

    msiexec /i $msi /qn

}

# Verifica se esta instalado
if ((Get-Service -Name "*hardwaresupervisor*" -ErrorAction SilentlyContinue) -ne $null) {

  echo "ja instalado"

} else {

  Instalar

}
