#!/bin/bash
# =============================================================================
#  ASSIO (88020) - Practica 2: Sistema de archivos, comandos, usuarios y permisos
#  Escenario AURORA Aerospace - Proyecto AURORA-6
#  Grupo 8: Eva Maria Ramos Juarez (A), Alberto Garcia Martin (B),
#           Javier Jiahao Cheng Hu (C)
#  Uso: bash 88020_P2_Script_AGJCER.sh <parte>   (parte = 1..6, o "todo")
#  Se ejecuta con la cuenta de administracion (eva) y usa sudo.
# =============================================================================
H=$(hostname)
B=/srv/aurora6
# Muestra el comando como en la terminal del usuario indicado y lo ejecuta como ese usuario
como() { local u=$1; shift
  if [ "$u" = root ]; then printf '\033[1;31m%s@%s\033[0m:\033[1;34m~\033[0m# %s\n' "$u" "$H" "$*"; sudo bash -c "$*"
  else printf '\033[1;32m%s@%s\033[0m:\033[1;34m~\033[0m$ %s\n' "$u" "$H" "$*"; sudo -u "$u" -H bash -c "cd ~; $*"; fi
  echo "    [codigo de salida: $?]"; }
adm() { printf '\033[1;32meva@%s\033[0m:\033[1;34m~\033[0m$ sudo %s\n' "$H" "$*"; sudo bash -c "$*"; }
titulo() { echo; echo "=================== $* ==================="; }
pausa() { echo; read -r -p "------ [Intro para continuar] ------" _; clear; }

p1() { # 1) Primer acceso e identificacion basica (cada integrante)
  for u in eva alberto javier; do
    titulo "1) Identificacion - usuario $u"
    como $u 'whoami; hostname; pwd'
    como $u 'ls /'
    como $u 'ls -l /home'
    como $u 'ls /root'
    pausa
  done
  titulo "1) /root solo con sudo"; adm 'ls -la /root'; pausa
}

p2() { # 2) Estructura de la empresa
  titulo "2) Creacion de la estructura /srv/aurora6"
  adm "mkdir -p $B/ingenieria/{mecanica,avionica,software} $B/compras/{proveedores,pedidos} $B/contabilidad/facturas $B/documentacion/comun $B/confidencial $B/intercambio/{incoming,approved,quarantine}"
  command -v tree >/dev/null || sudo apt-get install -y -qq tree acl >/dev/null
  adm "tree -d $B"
  pausa
}

p3() { # 3) Usuarios, grupos y roles
  titulo "3) Grupos de departamento y cuentas"
  adm 'for g in mecanica avionica software compras proyecto; do getent group $g >/dev/null || groupadd $g; done'
  adm 'id alberto >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Alberto Garcia Martin" alberto'
  adm 'id javier  >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Javier Jiahao Cheng Hu" javier'
  adm 'usermod -aG mecanica,proyecto eva'
  adm 'usermod -aG avionica,software,proyecto alberto'
  adm 'usermod -aG compras,proyecto javier'
  pausa
  titulo "3) Comprobacion de pertenencias"
  for u in eva alberto javier; do adm "id $u"; adm "groups $u"; done
  adm 'getent group mecanica avionica software compras proyecto'
  pausa
}

p4() { # 4) Permisos DAC y configuracion 751
  titulo "4) documentacion: grupo proyecto y permisos 751"
  adm "chown root:proyecto $B/documentacion"
  adm "chmod 751 $B/documentacion"
  adm "ls -ld $B/documentacion"
  adm "stat -c '%A %a %U:%G %n' $B/documentacion"
  pausa
}

p5() { # 5) Politica de acceso por roles y ACLs
  titulo "5) Base comun: /srv/aurora6, ingenieria e intercambio"
  adm "chown root:proyecto $B $B/ingenieria && chmod 750 $B $B/ingenieria"
  adm "chown -R root:proyecto $B/intercambio && chmod -R 2770 $B/intercambio"
  adm "chown root:root $B/confidencial && chmod 700 $B/confidencial"
  adm "chmod 750 $B/documentacion"
  pausa
  titulo "5) Miembro A (eva) - mecanica + ACL de lectura para avionica"
  adm "chown root:mecanica $B/ingenieria/mecanica && chmod 2770 $B/ingenieria/mecanica"
  adm "setfacl -m g:avionica:rx -m d:g:avionica:rx -m d:g:mecanica:rwx $B/ingenieria/mecanica"
  adm "getfacl -p $B/ingenieria/mecanica"
  pausa
  titulo "5) Miembro B (alberto) - avionica/software + ACL de lectura para mecanica"
  adm "chown root:avionica $B/ingenieria/avionica && chmod 2770 $B/ingenieria/avionica"
  adm "chown root:software $B/ingenieria/software && chmod 2770 $B/ingenieria/software"
  adm "setfacl -m g:mecanica:rx -m d:g:mecanica:rx -m d:g:avionica:rwx $B/ingenieria/avionica"
  adm "getfacl -p $B/ingenieria/avionica"
  pausa
  titulo "5) Miembro C (javier) - compras, documentacion/comun y ACL de facturas"
  adm "chown -R root:compras $B/compras && chmod -R 2770 $B/compras"
  adm "chown root:proyecto $B/documentacion/comun && chmod 2750 $B/documentacion/comun"
  adm "setfacl -m g:compras:rwx -m d:g:compras:rwx -m d:g:proyecto:rx $B/documentacion/comun"
  adm "chown root:root $B/contabilidad $B/contabilidad/facturas && chmod 700 $B/contabilidad && chmod 750 $B/contabilidad/facturas"
  adm "setfacl -m g:compras:x $B/contabilidad && setfacl -m g:compras:rx -m d:g:compras:rx $B/contabilidad/facturas"
  adm "getfacl -p $B/contabilidad/facturas"
  pausa
  titulo "5) Ficheros de ejemplo y resumen final"
  adm "echo 'Factura 2026-001 - proveedor de titanio' > $B/contabilidad/facturas/factura_2026_001.txt"
  adm "echo 'Normas comunes del proyecto AURORA-6' > $B/documentacion/comun/normas_proyecto.txt"
  adm "echo 'Plan secreto' > $B/confidencial/plan_secreto.txt"
  adm "ls -l $B $B/ingenieria $B/compras $B/contabilidad $B/documentacion"
  pausa
}

p6() { # 6) Validacion individual
  titulo "6) Validacion - Miembro A: eva (Ingenieria mecanica)"
  como eva "echo 'Ensayo de estructura n1' > $B/ingenieria/mecanica/ensayo_estructura.txt && ls -l $B/ingenieria/mecanica"
  como eva "ls $B/ingenieria/avionica && cat $B/documentacion/comun/normas_proyecto.txt"
  como eva "touch $B/ingenieria/avionica/prueba_eva.txt"
  como eva "ls $B/contabilidad"
  como eva "ls $B/confidencial; ls $B/compras/pedidos"
  pausa
  como eva "getfacl -p $B/ingenieria/mecanica"
  pausa
  titulo "6) Validacion - Miembro B: alberto (Avionica y software)"
  como alberto "echo 'Telemetria vuelo 1' > $B/ingenieria/avionica/telemetria.txt && echo 'v1.0' > $B/ingenieria/software/version.txt && ls -l $B/ingenieria/avionica $B/ingenieria/software"
  como alberto "cat $B/ingenieria/mecanica/ensayo_estructura.txt"
  como alberto "touch $B/ingenieria/mecanica/prueba_alberto.txt"
  como alberto "ls $B/confidencial"
  como alberto "ls $B/contabilidad; ls $B/compras/pedidos"
  pausa
  como alberto "getfacl -p $B/ingenieria/avionica"
  pausa
  titulo "6) Validacion - Miembro C: javier (Compras y configuracion)"
  como javier "echo 'Pedido 001 - 20 placas de titanio' > $B/compras/pedidos/pedido_001.txt && ls -l $B/compras/pedidos"
  como javier "cat $B/contabilidad/facturas/factura_2026_001.txt && ls $B/documentacion/comun"
  como javier "touch $B/ingenieria/mecanica/prueba_javier.txt"
  como javier "ls $B/confidencial"
  como javier "touch $B/contabilidad/facturas/nueva.txt"
  pausa
  como javier "getfacl -p $B/contabilidad/facturas"
  pausa
}

sudo -v || exit 1
case "${1:-todo}" in
  1) p1;; 2) p2;; 3) p3;; 4) p4;; 5) p5;; 6) p6;;
  todo) p3; p1; p2; p4; p5; p6;;
esac
