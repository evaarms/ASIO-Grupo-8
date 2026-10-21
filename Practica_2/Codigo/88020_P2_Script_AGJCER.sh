#!/bin/bash
# =============================================================================
#  ASSIO (88020) - Practica 2: Sistema de archivos, comandos, usuarios y permisos
#  Escenario AURORA Aerospace - Proyecto AURORA-6
#  Grupo 8: Eva Maria Ramos Juarez (A), Alberto Garcia Martin (B),
#           Javier Jiahao Cheng Hu (C)
#  Uso: bash 88020_P2_Script_AGJCER.sh [1-8|m|c|limpiar|todo]
#  Se ejecuta con la cuenta de administracion (eva) y usa sudo.
# =============================================================================
H=$(hostname); B=/srv/aurora6; CRED=/root/aurora6_credenciales.txt
R='\033[0m'; V='\033[1;32m'; Z='\033[1;34m'; M='\033[1;35m'; RJ='\033[1;31m'; AM='\033[1;33m'; C='\033[1;36m'

ADMIN=$(id -un)   # cuenta que ejecuta el script (la administradora)
NOPERM="Acceso restringido: no dispones de los permisos necesarios"
NOADMIN="Acceso restringido: no tienes permisos de administrador"
# Muestra el comando como en la terminal del usuario indicado y lo ejecuta como ese usuario.
# Los errores de permisos del sistema se sustituyen por un mensaje claro para el usuario.
como() { local u=$1; shift
  printf "${V}%s@%s${R}:${Z}~${R}\$ %s\n" "$u" "$H" "$*"
  local err; err=$(mktemp)
  sudo -u "$u" -H bash -c "cd ~; $*" 2>"$err"; local e=$?
  if grep -qiE "sorry|sudoers|not allowed to run sudo|password is required|se requiere una contrase" "$err"; then printf "    ${RJ}%s${R}\n" "$NOADMIN"
  elif grep -qiE "permission denied|permiso denegado|operation not permitted|operaci.n no permitida" "$err"; then printf "    ${RJ}%s${R}\n" "$NOPERM"
  else cat "$err"; fi
  rm -f "$err"
  if [ $e -eq 0 ]; then printf "    ${V}[OK - codigo %s]${R}\n" $e; else printf "    ${RJ}[DENEGADO - codigo %s]${R}\n" $e; fi; }
adm() { printf "${V}%s@%s${R}:${Z}~${R}\$ sudo %s\n" "$ADMIN" "$H" "$*"; sudo bash -c "$*"; }
titulo() { echo; printf "${M}== %s ==${R}\n" "$*"; }
pausa() { echo; read -r -p "------ [Intro para continuar] ------" _; clear; }

portada() { clear; printf "${C}"
cat <<'EOF'
     _   _   _ ____   ___  ____      _        __
    / \ | | | |  _ \ / _ \|  _ \    / \      / /_
   / _ \| | | | |_) | | | | |_) |  / _ \    | '_ \
  / ___ \ |_| |  _ <| |_| |  _ <  / ___ \   | (_) |
 /_/   \_\___/|_| \_\\___/|_| \_\/_/   \_\   \___/
EOF
printf "${R}  AURORA Aerospace - servidor %s - ASSIO P2 - Grupo 8\n" "$H"; pausa; }

p1() { # 1) Primer acceso e identificacion basica
  titulo "1) Identificacion: quien soy, donde estoy y en que equipo"
  como eva 'whoami; hostname; pwd'
  como eva 'ls /'
  como eva 'ls -l /home'
  pausa
  titulo "1) /root es el directorio del administrador"
  como eva 'ls /root'
  adm 'ls -ld /root'
  adm 'ls -la /root | head -5'
  pausa
}

p2() { # 2) Estructura de la empresa
  titulo "2) Estructura del proyecto en /srv/aurora6"
  command -v tree >/dev/null && command -v setfacl >/dev/null || { adm 'apt-get install -y -qq tree acl >/dev/null'; }
  adm "mkdir -p $B/ingenieria/{mecanica,avionica,software} $B/compras/{proveedores,pedidos} $B/contabilidad/facturas $B/documentacion/comun $B/confidencial $B/intercambio/{incoming,approved,quarantine}"
  adm "tree -d $B"
  pausa
}

alta() { # alta <usuario> "<Nombre>" <grupos>: crea la cuenta con contrasena temporal aleatoria
  local u=$1 n=$2 g=$3
  if ! id "$u" >/dev/null 2>&1; then
    adm "useradd -m -s /bin/bash -c '$n' $u"
    local pw; pw=$(openssl rand -base64 9)
    echo "$u:$pw" | sudo chpasswd
    printf "%-8s %s\n" "$u" "$pw" | sudo tee -a $CRED >/dev/null
    printf "${AM}    (contrasena temporal de %s generada y guardada en %s)${R}\n" "$u" "$CRED"
    adm "chage -d 0 $u"
  fi
  [ -n "$g" ] && adm "usermod -aG $g $u"
}

p3() { # 3) Usuarios, grupos y roles
  titulo "3) Grupos de departamento"
  adm 'for g in mecanica avionica software compras proyecto; do getent group $g >/dev/null || groupadd $g; done'
  adm 'getent group mecanica avionica software compras proyecto'
  pausa
  titulo "3) Cuentas de los responsables (contrasena temporal, cambio obligatorio)"
  sudo touch $CRED; sudo chmod 600 $CRED
  alta eva     "Eva Maria Ramos Juarez" mecanica,proyecto
  alta alberto "Alberto Garcia Martin"  avionica,software,proyecto
  alta javier  "Javier Jiahao Cheng Hu" compras,proyecto
  adm "ls -l $CRED"
  adm 'passwd -S alberto; passwd -S javier'
  pausa
  titulo "3) Comprobacion de pertenencias"
  for u in eva alberto javier; do adm "id $u"; done
  adm 'groups eva alberto javier'
  pausa
}

p4() { # 4) Permisos DAC y configuracion 751
  titulo "4) documentacion: grupo proyecto y permisos 751"
  adm "chown root:proyecto $B/documentacion"
  adm "chmod 751 $B/documentacion"
  adm "ls -ld $B/documentacion"
  adm "stat -c '%A  %a  %U:%G  %n' $B/documentacion"
  pausa
}

p5() { # 5) Politica por roles: DAC + ACL
  titulo "5) Base comun: raiz, ingenieria, intercambio y confidencial"
  adm "chown root:proyecto $B $B/ingenieria && chmod 750 $B $B/ingenieria"
  adm "chown -R root:proyecto $B/intercambio && chmod -R 2770 $B/intercambio"
  adm "chown root:root $B/confidencial && chmod 700 $B/confidencial"
  adm "chmod 750 $B/documentacion"
  pausa
  titulo "5) Miembro A (eva): mecanica + ACL de lectura para avionica"
  adm "chown root:mecanica $B/ingenieria/mecanica && chmod 2770 $B/ingenieria/mecanica"
  adm "setfacl -m g:avionica:rx,d:g:avionica:rx,d:g:mecanica:rwx $B/ingenieria/mecanica"
  adm "getfacl -p $B/ingenieria/mecanica"
  pausa
  titulo "5) Miembro B (alberto): avionica y software + ACL de lectura para mecanica"
  adm "chown root:avionica $B/ingenieria/avionica && chmod 2770 $B/ingenieria/avionica"
  adm "chown root:software $B/ingenieria/software && chmod 2770 $B/ingenieria/software"
  adm "setfacl -m g:mecanica:rx,d:g:mecanica:rx,d:g:avionica:rwx $B/ingenieria/avionica"
  adm "setfacl -m d:g:software:rwx $B/ingenieria/software"
  adm "getfacl -p $B/ingenieria/avionica"
  pausa
  titulo "5) Miembro C (javier): compras, documentacion/comun y facturas"
  adm "chown -R root:compras $B/compras && chmod -R 2770 $B/compras"
  adm "setfacl -R -m d:g:compras:rwx $B/compras"
  adm "chown root:proyecto $B/documentacion/comun && chmod 2750 $B/documentacion/comun"
  adm "setfacl -m g:compras:rwx,d:g:compras:rwx,d:g:proyecto:rx $B/documentacion/comun"
  adm "chown root:root $B/contabilidad $B/contabilidad/facturas && chmod 700 $B/contabilidad && chmod 750 $B/contabilidad/facturas"
  adm "setfacl -m g:compras:x $B/contabilidad && setfacl -m g:compras:rx,d:g:compras:rx $B/contabilidad/facturas"
  adm "getfacl -p $B/contabilidad/facturas"
  pausa
  titulo "5) Acceso directo de cada responsable a su area"
  adm "ln -sfn $B/ingenieria/mecanica /home/eva/mecanica"
  adm "ln -sfn $B/ingenieria/avionica /home/alberto/avionica && ln -sfn $B/ingenieria/software /home/alberto/software"
  adm "ln -sfn $B/compras /home/javier/compras"
  adm "echo 'Factura 2026-001 - proveedor de titanio' > $B/contabilidad/facturas/factura_2026_001.txt"
  adm "echo 'Normas comunes del proyecto AURORA-6' > $B/documentacion/comun/normas_proyecto.txt"
  adm "echo 'Plan secreto' > $B/confidencial/plan_secreto.txt"
  adm "ls -l $B $B/ingenieria"
  pausa
}

p6() { # 6) Validacion individual
  titulo "6) Validacion - Miembro A: eva (Ingenieria mecanica)"
  como eva "echo 'Ensayo de estructura n1' > mecanica/ensayo_estructura.txt && ls -l mecanica/"
  como eva "ls $B/ingenieria/avionica && cat $B/documentacion/comun/normas_proyecto.txt"
  como eva "touch $B/ingenieria/avionica/prueba_eva.txt"
  como eva "ls $B/contabilidad"
  como eva "ls $B/confidencial"
  pausa
  titulo "6) Validacion - Miembro B: alberto (Avionica y software)"
  como alberto "echo 'Telemetria vuelo 1' > avionica/telemetria.txt && echo 'v1.0' > software/version.txt && ls -l avionica/ software/"
  como alberto "cat $B/ingenieria/mecanica/ensayo_estructura.txt"
  como alberto "touch $B/ingenieria/mecanica/prueba_alberto.txt"
  como alberto "ls $B/compras/pedidos"
  como alberto "ls $B/confidencial"
  pausa
  titulo "6) Validacion - Miembro C: javier (Compras y configuracion)"
  como javier "echo 'Pedido 001 - 20 placas de titanio' > compras/pedidos/pedido_001.txt && ls -l compras/pedidos/"
  como javier "cat $B/contabilidad/facturas/factura_2026_001.txt && ls $B/documentacion/comun"
  como javier "touch $B/contabilidad/facturas/nueva.txt"
  como javier "touch $B/ingenieria/mecanica/prueba_javier.txt"
  como javier "ls $B/confidencial"
  pausa
  titulo "6) getfacl de cada area (ejecutado por su responsable)"
  como eva "getfacl -p $B/ingenieria/mecanica | grep -v '^#'"
  como javier "getfacl -p $B/contabilidad/facturas | grep -v '^#'"
  pausa
  matriz
}

matriz() { # Matriz de accesos: L = lectura, E = escritura, - = sin acceso
  titulo "6) Matriz de accesos comprobada en el sistema (L=leer, E=escribir)"
  local dirs="ingenieria/mecanica ingenieria/avionica ingenieria/software compras/pedidos contabilidad/facturas documentacion/comun confidencial"
  local us="eva alberto javier"; id becario >/dev/null 2>&1 && us="$us becario"; id director >/dev/null 2>&1 && us="$us director"
  printf "%-24s" "Directorio"; for u in $us; do printf " %-9s" "$u"; done; echo
  for d in $dirs; do printf "%-24s" "$d"
    for u in $us; do
      r=-; w=-  # se usa el test interno de bash: el /usr/bin/test de Ubuntu 26.04 no admite -a
      sudo -u $u bash -c "[ -r $B/$d ] && [ -x $B/$d ]" 2>/dev/null && r=L
      sudo -u $u bash -c "[ -w $B/$d ] && [ -x $B/$d ]" 2>/dev/null && w=E
      if [ "$r$w" = "--" ]; then printf " ${RJ}%-9s${R}" "--"; else printf " ${V}%-9s${R}" "$r$w"; fi
    done; echo; done
  pausa
}

p7() { # 7) Mejoras dentro del temario: intercambio, copia de permisos, skel, becario y auditoria
  titulo "7.1) Intercambio: flujo incoming -> approved -> quarantine con sticky bit"
  adm "chown root:proyecto $B/intercambio/incoming && chmod 3770 $B/intercambio/incoming"
  adm "chown root:proyecto $B/intercambio/approved && chmod 2750 $B/intercambio/approved && setfacl -m g:compras:rwx,d:g:compras:rwx,d:g:proyecto:rx $B/intercambio/approved"
  adm "chown root:compras $B/intercambio/quarantine && chmod 2770 $B/intercambio/quarantine"
  adm "ls -l $B/intercambio"
  pausa
  titulo "7.1) Prueba del sticky bit: solo el autor borra su fichero"
  como eva "echo 'Plano ala v3' > $B/intercambio/incoming/plano_ala.txt && ls -l $B/intercambio/incoming"
  como alberto "rm -f $B/intercambio/incoming/plano_ala.txt"
  como javier "cp $B/intercambio/incoming/plano_ala.txt $B/intercambio/approved/ && ls -l $B/intercambio/approved"
  como alberto "touch $B/intercambio/approved/prueba_alberto.txt"
  como alberto "ls $B/intercambio/quarantine"
  pausa
  titulo "7.2) Copia de seguridad de permisos y ACL con getfacl -R"
  adm "getfacl -R -p $B > /root/aurora6_permisos.acl && wc -l /root/aurora6_permisos.acl"
  adm "chmod 777 $B/confidencial && setfacl -b $B/ingenieria/mecanica"
  adm "ls -ld $B/confidencial $B/ingenieria/mecanica"
  printf "${AM}    (permisos rotos a proposito: confidencial abierto a todos y mecanica sin ACL)${R}\n"
  pausa
  titulo "7.2) Restauracion con setfacl --restore"
  adm "setfacl --restore=/root/aurora6_permisos.acl"
  adm "ls -ld $B/confidencial $B/ingenieria/mecanica"
  adm "getfacl -p $B/ingenieria/mecanica | grep avionica"
  pausa
  titulo "7.3) Plantilla /etc/skel: bienvenida para las cuentas nuevas"
  adm "printf 'Bienvenido/a al proyecto AURORA-6 (servidor %s).\\nTu area de trabajo esta en /srv/aurora6.\\nLa contrasena inicial es temporal: el sistema te pedira cambiarla.\\n' $H > /etc/skel/LEEME_AURORA6.txt"
  adm "ls -l /etc/skel"
  pausa
  titulo "7.4) Politica de contrasenas y cuenta de becario temporal"
  adm "chage -M 90 -m 1 -W 7 alberto && chage -M 90 -m 1 -W 7 javier"
  adm "chage -l alberto"
  alta becario "Becario de documentacion" ""
  adm "chage -E 2026-12-31 -M 90 -W 7 becario && chage -l becario | head -4"
  adm "setfacl -m u:becario:x $B && setfacl -m u:becario:x $B/documentacion && setfacl -R -m u:becario:rX,d:u:becario:rX $B/documentacion/comun"
  adm "ls /home/becario"
  pausa
  titulo "7.4) Validacion del becario: solo lectura en documentacion/comun"
  como becario "cat $B/documentacion/comun/normas_proyecto.txt"
  como becario "touch $B/documentacion/comun/prueba_becario.txt"
  como becario "ls $B/ingenieria"
  como becario "ls $B"
  pausa
  titulo "7.5) Informe de auditoria de /srv/aurora6"
  adm "{ echo \"Auditoria AURORA-6 - \$(date +%F)\"; echo '* Directorios escribibles por cualquiera:'; find $B -perm -o+w; echo '* Ficheros sin propietario o grupo valido:'; find $B -nouser -o -nogroup; echo '* Directorios con setgid:'; find $B -type d -perm -2000 | wc -l; echo '* Ficheros y directorios con ACL:'; getfacl -R -s -p $B 2>/dev/null | grep -c '^# file'; echo '* Espacio por area:'; du -sh $B/*; } | tee /root/auditoria_aurora6.txt"
  pausa
  matriz
}

p8() { # 8) Cuenta de direccion (administradora) separada de los responsables
  titulo "8) Cuenta director: jefa del proyecto y unica administradora"
  if ! id director >/dev/null 2>&1; then
    adm "useradd -m -s /bin/bash -c 'Direccion del proyecto AURORA-6' director"
    printf "${AM}    Escribe ahora la contrasena que quieras para director (dos veces):${R}\n"
    until sudo passwd director; do echo "    Repite la contrasena"; done
  fi
  adm "usermod -aG sudo,proyecto,mecanica,avionica,software,compras director"
  adm "ln -sfn $B /home/director/aurora6"
  adm "id director"
  adm "getent group sudo"
  pausa
  titulo "8) eva deja de ser administradora: solo responsable de mecanica"
  getent group sudo | grep -qw eva && adm "gpasswd -d eva sudo"
  adm "id eva; getent group sudo"
  como eva "sudo -n ls $B/confidencial"
  adm "ls -l $B/confidencial"
  printf "${AM}    La administracion se hace iniciando sesion como director.${R}\n"
  pausa
  matriz
}

correccion() { # Comprobacion de las correcciones tras la primera ejecucion
  titulo "Correccion: ACL por defecto en software y compras (ficheros nuevos con rw para el grupo)"
  adm "setfacl -m d:g:software:rwx $B/ingenieria/software && setfacl -R -m d:g:compras:rwx $B/compras"
  como alberto "echo 'v1.1' > software/version2.txt && ls -l software/"
  como javier "echo 'Pedido 002 - 40 tornillos' > compras/pedidos/pedido_002.txt && ls -l compras/pedidos/"
  pausa
  matriz
}

limpiar() { # Deja el servidor como antes de la practica (para repetirla desde cero)
  titulo "Limpieza: se eliminan cuentas, grupos y /srv/aurora6 de ejecuciones anteriores"
  adm "userdel -r alberto 2>/dev/null; userdel -r javier 2>/dev/null; userdel -r becario 2>/dev/null; rm -f /home/eva/mecanica $CRED /etc/skel/LEEME_AURORA6.txt"
  adm "rm -rf $B"
  adm 'for g in mecanica avionica software compras proyecto; do groupdel $g 2>/dev/null; done; id eva'
}

sudo -v || exit 1
case "${1:-todo}" in
  1) p1;; 2) p2;; 3) p3;; 4) p4;; 5) p5;; 6) p6;; 7) p7;; 8) p8;; m) matriz;; limpiar) limpiar;; c) correccion;;
  todo) portada; p1; p2; p3; p4; p5; p6; p7;;
esac
