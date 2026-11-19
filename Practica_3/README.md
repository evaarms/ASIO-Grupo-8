<div align="center">

# P3 · Acceso remoto SSH y administración de servicios con systemd

**Administración y Servicios de Sistemas Operativos (88020)** · Grupo 8

![Issue](https://img.shields.io/badge/issue-I003-872046)
![SO](https://img.shields.io/badge/Ubuntu%20Server-26.04%20LTS-E95420?logo=ubuntu&logoColor=white)
![VirtualBox](https://img.shields.io/badge/VirtualBox-NAT%202222%E2%86%9222-183A61?logo=virtualbox&logoColor=white)
![systemd](https://img.shields.io/badge/systemd-servicios%20endurecidos-30D475)

</div>

---

## 📝 Descripción

Sobre el servidor `server-asio-01` de las prácticas anteriores (proyecto ficticio **AURORA-6** de AURORA Aerospace) se verifica el **acceso remoto por SSH** de cada integrante con su propia cuenta y se administra con **systemd** un servicio de monitorización por miembro.

Los simuladores los proporciona el profesor y se despliegan **sin modificarlos**. Cada servicio se ejecuta con el usuario de su rol, siguiendo el principio de **mínimo privilegio**, se aísla con las opciones de seguridad de systemd, se recupera solo ante un fallo y, por último, se bloquea el acceso directo de `root` por SSH.

**Issue:** [`I003`](https://github.com/evaarms/ASIO-Grupo-8/issues/11) · **Ramas:** `I003_Documentacion_ERJ` (documentación) · `I003_Codigo_ERJ` (código)

---

## 👥 Integrantes y roles

| Miembro | Integrante | Usuario | Servicio | Simulador |
|---|---|---|---|---|
| **A** | Eva María Ramos Juárez | `eva` | `structure-monitor.service` | `structure-monitor.sh` (estructura) |
| **B** | Alberto García Martín | `alberto` | `telemetry-monitor.service` | `telemetry-monitor.sh` (telemetría) |
| **C** | Javier Jiahao Cheng Hu | `javier` | `supply-monitor.service` | `supply-monitor.sh` (suministros) |

La administración se hace desde la cuenta `director`, la única con `sudo` desde la P2.

---

## 🖥️ Entorno

| | |
|---|---|
| **Servidor** | `server-asio-01` · Ubuntu Server 26.04.1 LTS |
| **Virtualización** | VirtualBox (VM `Ubuntu-Server-ASSIO`) sobre Mac Apple Silicon |
| **Red** | NAT con reenvío de puertos **`2222 (anfitrión) → 22 (VM)`** |
| **Acceso** | `ssh -p 2222 <usuario>@localhost` desde el anfitrión |
| **Simuladores** | `/opt/aurora6/tools/` (propiedad de `root:root`, permisos `755`) |
| **Unidades** | `/etc/systemd/system/{structure,telemetry,supply}-monitor.service` |

---

## ✅ Lo realizado

1. **Conectividad SSH y modo NAT**: se revisa la regla `2222 → 22` en VirtualBox y que `sshd` escucha en el puerto 22.
2. **Sesión SSH individual**: `eva`, `alberto` y `javier` entran con su cuenta y se comprueban `whoami`, `id` y `$SSH_CONNECTION`.
3. **Gestión de servicios con `systemctl`**: estado de `ssh` y `ssh.socket` (activación por socket) y pruebas de parada, arranque, reinicio y habilitación con `cron`.
4. **Servicios systemd individuales**: una unidad por miembro con `User=` del rol, `Restart=on-failure` y `RestartSec=3`.
5. **Protección y aislamiento**:
   - Ejecutable de `root:root` con permisos `755`: cada rol puede ejecutarlo, pero no modificarlo (se comprueba desde cada cuenta).
   - Endurecimiento con `NoNewPrivileges=true`, `PrivateTmp=true`, `ProtectHome=true` y `ProtectSystem=full`.
   - Ampliación a `ProtectSystem=strict` y valoración con `systemd-analyze security`.
6. **Recuperación automática**: se mata el proceso principal con `SIGKILL` y systemd lo relanza (nuevo `MainPID` y `NRestarts` incrementado).
7. **Registros**: verificación con `journalctl` de cada servicio y de `ssh`.
8. **Bloqueo de `root` por SSH**: `PermitRootLogin no`, validado con `sshd -t` y comprobado con `sshd -T` y con un intento de conexión rechazado.
9. **Extra: seguridad adicional de SSH**: `AllowUsers director eva alberto javier`, `MaxAuthTries 3` y `LoginGraceTime 30` en `/etc/ssh/sshd_config.d/10-p3-seguridad.conf` (por ejemplo, `becario` queda rechazado).

---

## 📁 Estructura de la carpeta

```
Practica_3/
├── README.md
├── Documentacion/                            # Rama I003_Documentacion_ERJ
│   └── 88020_P3_Memoria_AGJCER.pdf            # Memoria del grupo
├── Presentacion/                             # Rama I003_Documentacion_ERJ
│   └── 88020_P3_Presentacion_AGJCER.pdf       # Diapositivas
├── Anexos/                                   # Rama I003_Documentacion_ERJ
│   ├── 88020_P3_Enunciado_AGJCER.pdf          # Enunciado del profesor (documento de referencia)
│   └── 88020_P3_Guion_AGJCER.pdf              # Guion de la presentación
└── Codigo/                                   # Rama I003_Codigo_ERJ
    ├── 88020_P3_Script_AGJCER.sh              # Script de la práctica
    └── 88020_P3_Comandos_AGJCER.txt           # Comandos utilizados
```

| Archivo | Contenido |
|---|---|
| **Memoria** | Todos los apartados con capturas del servidor: regla NAT y topología, sesión SSH de cada integrante, `systemctl` y `ssh.socket`, los tres servicios, protección y aislamiento, recuperación ante `SIGKILL`, registros, `PermitRootLogin no` y problemas encontrados con su solución. |
| **Presentación** | 12 diapositivas que explican lo realizado y cómo queda protegido cada servicio. |
| **Enunciado** | Enunciado de la práctica entregado por el profesor. |
| **Guion** | Guion de la exposición de la presentación. |
| **Script** | Automatiza la práctica por apartados, con la opción `limpiar`. |
| **Comandos** | Todos los comandos de cada apartado, indicando el usuario que ejecuta cada uno (`[mac]`, `[director]`, `[eva]`…). |

---

## ▶️ Cómo ejecutar el script

**Requisitos:** servidor `server-asio-01` con las cuentas de la P2 (`director`, `eva`, `alberto` y `javier`), acceso por SSH desde el anfitrión y los simuladores del profesor copiados en `~/p3_scripts` (o en la ruta que indique la variable `P3_SCRIPTS`).

```bash
# Desde el anfitrión, con la cuenta de administración
ssh -p 2222 director@localhost

# En el servidor
bash 88020_P3_Script_AGJCER.sh            # todos los apartados, con pausa entre ellos
bash 88020_P3_Script_AGJCER.sh 4          # un apartado concreto (1-9; 9 = extra de seguridad SSH)
bash 88020_P3_Script_AGJCER.sh limpiar    # retira servicios y unidades y restaura la configuración SSH (conserva los simuladores)
```

El script usa `sudo` y ejecuta las comprobaciones de cada rol con `sudo -u <usuario>`. Los comandos del fichero `88020_P3_Comandos_AGJCER.txt` pueden ejecutarse uno a uno con el usuario indicado entre corchetes. Ni el script ni la documentación incluyen contraseñas ni claves.

---

<div align="center">
<sub>Universidad Camilo José Cela · Curso 2026/2027</sub>
</div>
