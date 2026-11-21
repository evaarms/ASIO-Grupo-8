#!/bin/bash
# =============================================================================
#  ASSIO (88020) - Practica 3: Acceso remoto SSH y administracion de servicios
#  con systemd. Escenario AURORA Aerospace - Proyecto AURORA-6
#  Grupo 8: Eva Maria Ramos Juarez, Alberto Garcia Martin,
#           Javier Jiahao Cheng Hu.
#  Usuarios: eva (A, structure-monitor), alberto (B, telemetry-monitor),
#            javier (C, supply-monitor).
#  Uso: bash 88020_P3_Script_AGJCER.sh [1-9|limpiar|todo]   (9 = extra de seguridad SSH)
#  Se ejecuta con la cuenta de administracion (director) y usa sudo.
#  Los simuladores los proporciona el profesor: el script los instala sin
#  modificarlos (desde ~/p3_scripts), los administra, los protege y los recupera.
# =============================================================================
H=$(hostname); T=/opt/aurora6/tools; U=/etc/systemd/system; SRC=${P3_SCRIPTS:-$HOME/p3_scripts}
R='\033[0m'; V='\033[1;32m'; Z='\033[1;34m'; M='\033[1;35m'; RJ='\033[1;31m'; AM='\033[1;33m'; C='\033[1;36m'

ADMIN=$(id -un)   # (director)
NOPERM="Acceso restringido: no dispones de los permisos necesarios"
NOADMIN="Acceso restringido: no tienes permisos de administrador"
# miembro:script:servicio:descripcion
MIEMBROS="eva:structure-monitor.sh:structure-monitor:AURORA-6 monitor de estructura (miembro A, eva)
alberto:telemetry-monitor.sh:telemetry-monitor:AURORA-6 monitor de telemetria (miembro B, alberto)
javier:supply-monitor.sh:supply-monitor:AURORA-6 monitor de suministros (miembro C, javier)"

# errores de permisos (mensaje).
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
cada() { local l u s svc d; while IFS= read -r l; do IFS=: read -r u s svc d <<< "$l"; "$@" "$u" "$s" "$svc" "$d" </dev/null; done <<< "$MIEMBROS"; }

portada() { clear; printf "${C}"
cat <<'EOF'
     _   _   _ ____   ___  ____      _        __
    / \ | | | |  _ \ / _ \|  _ \    / \      / /_
   / _ \| | | | |_) | | | | |_) |  / _ \    | '_ \
  / ___ \ |_| |  _ <| |_| |  _ <  / ___ \   | (_) |
 /_/   \_\___/|_| \_\\___/|_| \_\/_/   \_\   \___/
EOF
printf "${R}  AURORA Aerospace - servidor %s - ASSIO P3 - Grupo 8\n" "$H"
printf "  SSH y servicios systemd: structure-monitor (A) - telemetry-monitor (B) - supply-monitor (C)\n"; }

unidad() { 
  printf '[Unit]\nDescription=%s\nAfter=network.target\n\n[Service]\nType=simple\nUser=%s\nExecStart=%s/%s\nRestart=on-failure\nRestartSec=3\n' "$3" "$1" "$T" "$2"
  if [ "$4" -ge 1 ]; then
    local ps=full; [ "$4" = 2 ] && ps=strict
    printf 'NoNewPrivileges=true\nPrivateTmp=true\nProtectHome=true\nProtectSystem=%s\n' "$ps"
  fi
  printf '\n[Install]\nWantedBy=multi-user.target\n'; }

p1() { # Conectividad SSH y modo NAT
  adm 'ip -br addr; ip route | head -3'
  adm "ss -tlnp | grep -E ':22\b'"
  printf "${AM}    En el Mac: VBoxManage showvminfo Ubuntu-Server-ASSIO --machinereadable | grep -i forwarding${R}\n"
  pausa
}

p2() { # Verificacion SSH individual
  for u in eva alberto javier; do
    como $u 'whoami; hostname; id; tty; echo "SSH_CONNECTION=[$SSH_CONNECTION]"'
    como $u "echo 'P3 - prueba de $u' > ~/p3_prueba_ssh.txt && ls -l ~/p3_prueba_ssh.txt"
  done
  printf "${AM}    Por SSH, \$SSH_CONNECTION muestra: IP cliente, puerto cliente, IP servidor y puerto servidor${R}\n"
  adm "journalctl -u ssh --no-pager | grep -E 'Accepted password' | tail -5"
  pausa
}

p3() { # Gestion de servicios con systemctl
  adm 'systemctl status ssh --no-pager | head -9; systemctl is-active ssh; systemctl is-enabled ssh'
  adm 'systemctl status ssh.socket --no-pager | head -8; systemctl is-enabled ssh.socket'
  pausa
  adm 'systemctl stop cron; systemctl is-active cron; systemctl start cron; systemctl is-active cron'
  adm 'systemctl restart cron; systemctl enable cron; systemctl is-enabled cron'
  pausa
}

instala() { [ -f "$SRC/$2" ] && adm "install -o root -g root -m 755 $SRC/$2 $T/$2"
  [ -f "$T/$2" ] || printf "${RJ}    Falta %s: hay que pedirlo al profesor (no se programa otro)${R}\n" "$T/$2"; }
crea() { unidad "$1" "$2" "$4" 0 | sudo tee $U/$3.service >/dev/null; adm "cat $U/$3.service"; }
arranca() { adm "systemctl enable --now $3.service; systemctl restart $3.service; sleep 2; systemctl is-enabled $3.service; systemctl status $3.service --no-pager | head -6"
  adm "ps -o user,pid,cmd -p \$(systemctl show -p MainPID --value $3.service)"; }

p4() { # Servicio systemd individual (cada miembro)
  adm "sha256sum $SRC/*.sh"
  adm "install -d -o root -g root -m 755 /opt/aurora6 $T"
  cada instala
  adm "sha256sum $T/*.sh; ls -l $T"
  pausa
  cada crea
  pausa
  adm 'systemctl daemon-reload'
  cada arranca
  adm "journalctl -u structure-monitor.service --since '5 minutes ago' --no-pager | tail -5"
  pausa
}

seguridad() { adm "systemd-analyze security $3.service --no-pager | tail -1 | sed 's/ [^[:alnum:]]*\$//'"; }   # sed quita el emoji final
permisos() { adm "namei -l $T/$2; stat -c '%U:%G %a %n' $T/$2 $U/$3.service"; }
escritura() { como "$1" "test -w $T/$2 && echo 'ALERTA: modificable' || echo 'OK: sin escritura'"
  como "$1" "echo prueba >> $T/$2"
  como "$1" "sudo -n -l"; }
endurece() { unidad "$1" "$2" "$4" "$NIVEL" | sudo tee $U/$3.service >/dev/null; }
efectiva() { adm "systemctl restart $3.service; sleep 2; systemctl show $3.service -p User -p NoNewPrivileges -p PrivateTmp -p ProtectHome -p ProtectSystem; systemctl is-active $3.service"; }

p5() { # Endurecimiento servicio y min privilegio
  cada seguridad
  pausa
  cada permisos
  adm "stat -c '%U:%G %a %n' /opt /opt/aurora6 $T"
  pausa
  
  cada escritura
  pausa
 
  NIVEL=1; cada endurece; adm 'systemctl daemon-reload'
  cada efectiva
  cada seguridad
  pausa
  
  NIVEL=2; cada endurece; adm 'systemctl daemon-reload'
  cada efectiva
  cada seguridad
  pausa
}

fallo() { adm "systemctl show $3.service -p MainPID -p NRestarts; systemctl kill --kill-who=main --signal=SIGKILL $3.service; sleep 5; systemctl status $3.service --no-pager | head -5; systemctl show $3.service -p MainPID -p NRestarts"; }
p6() { # Recuperacion automatica
  cada fallo
  pausa
}

registro() { adm "journalctl -u $3.service -n 15 --no-pager"; }
p7() { # Verificacion puntual registros
  cada registro
  adm 'journalctl -u ssh -n 10 --no-pager'
  pausa
}

p8() { # PermitRootLogin no (sin cerrar la sesion de director)
  [ -f /etc/ssh/sshd_config.bak_p3 ] || adm 'cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_p3'
  adm "sed -i -E 's/^\s*#?\s*PermitRootLogin.*/PermitRootLogin no/I' /etc/ssh/sshd_config; grep -nE '^\s*PermitRootLogin' /etc/ssh/sshd_config"
  if sudo /usr/sbin/sshd -t; then
    adm '/usr/sbin/sshd -t && echo "sshd -t: sintaxis correcta"; systemctl reload ssh; systemctl is-active ssh.socket ssh.service'
  else
    printf "${RJ}    Error de sintaxis: se restaura la copia y no se recarga ssh${R}\n"; adm 'cp -p /etc/ssh/sshd_config.bak_p3 /etc/ssh/sshd_config'; return 1
  fi
  adm '/usr/sbin/sshd -T -C user=root,host=localhost,addr=127.0.0.1 | grep -i permitrootlogin; passwd -S root'
  como "$ADMIN" 'ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 root@localhost true'
  pausa
}

p9() { # seguridad adicional conexiones SSH
  [ -f /etc/ssh/sshd_config.bak_p3_seg ] || adm 'cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config.bak_p3_seg'
  adm "printf '# P3 - seguridad adicional de las conexiones SSH\\nAllowUsers director eva alberto javier\\nMaxAuthTries 3\\nLoginGraceTime 30\\n' > /etc/ssh/sshd_config.d/10-p3-seguridad.conf; cat /etc/ssh/sshd_config.d/10-p3-seguridad.conf"
  if sudo /usr/sbin/sshd -t; then
    adm 'systemctl reload ssh; /usr/sbin/sshd -T | grep -iE "allowusers|maxauthtries|logingracetime|permitrootlogin"'
  else
    printf "${RJ}    Error de sintaxis: se retira el fichero y no se recarga ssh${R}\n"; adm 'rm -f /etc/ssh/sshd_config.d/10-p3-seguridad.conf'; return 1
  fi
  como "$ADMIN" 'ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 becario@localhost true'
  adm "journalctl -u ssh --since '5 minutes ago' --no-pager | grep -iE 'AllowUsers|maximum authentication|Too many|Timeout before authentication'"
  pausa
}

limpiar() {
  adm 'for s in structure-monitor telemetry-monitor supply-monitor; do systemctl disable --now $s.service 2>/dev/null; rm -f /etc/systemd/system/$s.service; done; systemctl daemon-reload'
  adm 'rm -f /etc/ssh/sshd_config.d/10-p3-seguridad.conf'
  [ -f /etc/ssh/sshd_config.bak_p3 ] && adm 'cp -p /etc/ssh/sshd_config.bak_p3 /etc/ssh/sshd_config && systemctl reload ssh'
}

case "${1:-todo}" in portada) portada; exit 0;; esac
sudo -v || exit 1
case "${1:-todo}" in
  1) p1;; 2) p2;; 3) p3;; 4) p4;; 5) p5;; 6) p6;; 7) p7;; 8) p8;; 9) p9;; limpiar) limpiar;;
  todo) portada; pausa; p1; p2; p3; p4; p5; p6; p7; p8; p9;;
esac
