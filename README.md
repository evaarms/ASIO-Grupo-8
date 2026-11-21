<div align="center">

# ASIO · Grupo 8

**Administración y Servicios de Sistemas Operativos (88020)**
Grado en Inteligencia Artificial y Robótica · Universidad Camilo José Cela

![Asignatura](https://img.shields.io/badge/asignatura-ASIO%2088020-872046)
![Prácticas](https://img.shields.io/badge/pr%C3%A1cticas-2-872046)
![SO](https://img.shields.io/badge/Ubuntu%20Server-26.04%20LTS-E95420?logo=ubuntu&logoColor=white)
![VirtualBox](https://img.shields.io/badge/VirtualBox-NAT%20%2B%20SSH-183A61?logo=virtualbox&logoColor=white)

</div>

---

## 👥 Equipo

| Integrante | GitHub |
|---|---|
| Eva María Ramos Juárez | [@evaarms](https://github.com/evaarms) |
| Alberto García Martín | [@toch-2303](https://github.com/toch-2303) |
| Javier Jiahao Cheng Hu | [@JavierChh](https://github.com/JavierChh) |

**Profesor:** Domingo José Sampedro Lirio

---

## 📚 Prácticas

| Issue | Práctica | Rama | Estado | Documentos |
|---|---|---|---|---|
| [`I001`](../../issues/1) | **P1** · Instalación de Ubuntu Server en una máquina virtual | `I001_Documentacion_ERJ` · `I001_Codigo_ERJ` | 🟡 En curso | [`Practica_1/`](Practica_1/) |
| [`I002`](../../issues/10) | **P2** · Sistema de archivos, comandos, usuarios y permisos | `I002_Documentacion_ERJ` · `I002_Codigo_ERJ` | 🟡 En curso | [`Practica_2/`](Practica_2/) |

---

## 🖥️ P1 · Instalación de Ubuntu Server en una máquina virtual

Cada integrante instaló Ubuntu Server en una VM de VirtualBox y documentó y justificó sus decisiones. La memoria del grupo reúne las tres instalaciones, apartado por apartado.

| | Eva María Ramos Juárez | Alberto García Martín | Javier Jiahao Cheng Hu |
|---|---|---|---|
| **Anfitrión** | Mac Apple Silicon (ARM64) | PC Windows (x86-64) | PC Windows (x86-64) |
| **ISO** | Ubuntu Server 26.04.1 arm64 | Ubuntu Server 24.04.3 amd64 | Ubuntu Server 26.04.1 amd64 |
| **RAM / CPU** | 2 GB / 2 vCPU | 2 GB / 1 vCPU | 2 GB / 2 vCPU |
| **Disco** | 25 GB VDI dinámico | 25 GB dinámico | 25 GB VDI dinámico |
| **Red** | NAT + reenvío `2222 → 22` | NAT | NAT |
| **Particiones** | `/boot/efi` · `/` · swap · `/home` | `/` · `/home` · `/var` · swap | `/` · swap |
| **Hostname** | `server-asio-01` | `albertoserver` | `server-asio` |
| **OpenSSH** | ✅ | ✅ | ✅ |

**Entregables:** memoria del grupo (Eva, Alberto y Javier), presentación (Eva) y fichero de comandos (Eva), en [`Practica_1/`](Practica_1/). En `Practica_1/Anexos/` están el enunciado del profesor (documento de referencia de la issue) y el guion de la presentación.

---

## 🗂️ P2 · Sistema de archivos, comandos, usuarios y permisos

En esta práctica se ha preparado el servidor `server-asio-01` (Ubuntu Server 26.04.1 LTS) para el proyecto ficticio **AURORA-6** de AURORA Aerospace:

* Estructura del proyecto en `/srv/aurora6` por departamentos.
* Grupos `mecanica`, `avionica`, `software`, `compras` y `proyecto`, y cuentas de los responsables (miembros A, B y C) con contraseña temporal.
* Permisos **DAC** (751 en `documentacion`) y política por roles con **ACL**, bit **setgid** y ACL por defecto.
* Validación individual de cada usuario y matriz de accesos.
* Extras: sticky bit en `intercambio`, copia y restauración de permisos, `/etc/skel`, política de contraseñas, cuenta temporal `becario`, auditoría, cuenta de dirección `director` y acceso remoto por **SSH**.

| Documento | Ruta |
|---|---|
| Memoria | `Practica_2/Documentacion/88020_P2_Memoria_AGJCER.pdf` |
| Presentación | `Practica_2/Presentacion/88020_P2_Presentacion_AGJCER.pdf` |
| Guion de la presentación | `Practica_2/Anexos/88020_P2_Guion_AGJCER.pdf` |
| Enunciado | `Practica_2/Anexos/88020_P2_Enunciado_AGJCER.pdf` |
| Script y comandos | `Practica_2/Codigo/88020_P2_Script_AGJCER.sh` · `Practica_2/Codigo/88020_P2_Comandos_AGJCER.txt` (rama `I002_Codigo_ERJ`) |

---

## 📁 Estructura del repositorio

```
ASIO-Grupo-8/
├── README.md
├── Practica_1/                              # Rama I001_Documentacion_ERJ (salvo Codigo/)
│   ├── Documentacion/
│   │   └── 88020_P1_Memoria_AGJCER.pdf       # Memoria del grupo
│   ├── Presentacion/
│   │   └── 88020_P1_Presentacion_AGJCER.pdf  # Diapositivas
│   ├── Codigo/
│   │   └── 88020_P1_Comandos_AGJCER.txt      # Comandos utilizados (rama I001_Codigo_ERJ)
│   └── Anexos/
│       ├── 88020_P1_Enunciado_AGJCER.pdf     # Enunciado del profesor (documento de referencia)
│       └── 88020_P1_Guion_AGJCER.pdf         # Guion de la presentación
└── Practica_2/                              # Rama I002_Documentacion_ERJ (salvo Codigo/)
    ├── Documentacion/
    │   └── 88020_P2_Memoria_AGJCER.pdf       # Memoria del grupo
    ├── Presentacion/
    │   └── 88020_P2_Presentacion_AGJCER.pdf  # Diapositivas
    ├── Codigo/                               # Rama I002_Codigo_ERJ
    │   ├── 88020_P2_Script_AGJCER.sh         # Script de la práctica
    │   └── 88020_P2_Comandos_AGJCER.txt      # Comandos utilizados
    └── Anexos/
        ├── 88020_P2_Enunciado_AGJCER.pdf     # Enunciado del profesor (documento de referencia)
        └── 88020_P2_Guion_AGJCER.pdf         # Guion de la presentación
```
---

## 🔀 Flujo de trabajo (guía GitHub de la asignatura)

1. **Issue por práctica**
   - ID: `Ixxx` (xxx = nº de issue). Ejemplo: `I001`.
   - Título: título de la práctica.
   - Descripción: tareas a realizar (lista de comprobación).
   - *Assignees*: **todos los integrantes del grupo**.
2. **Ramas** (una por tipo de tarea): `<IdIssue>_<Tipo>_<Iniciales>`.
   - `I001_Documentacion_ERJ`: toda la documentación (memoria, presentación y anexos: enunciado y guion).
   - `I001_Codigo_ERJ`: el código (fichero de comandos).
3. **Documentos**: dentro de la carpeta de la práctica (`Practica_1/`).
4. **Pull request** de cada rama a `main`, titulada como la issue + tipo (p. ej. `I001 - P1: … - Documentación`), con su etiqueta: `documentation` o `código`.
5. **Revisión**: máximo **2 revisiones** antes de fusionar.

```
issue I00x  ──►  ramas I00x_<Tipo>_XXX (Documentacion · Codigo)  ──►  commits  ──►  pull request  ──►  revisión (máx. 2)  ──►  main
```

### Nombre de los documentos

```
88020_P1_<Titulo>_AGJCER.<ext>     # Titulo = Memoria, Presentacion, Guion, Comandos o Enunciado
```

### Convención de commits

```
I001: descripción breve del cambio
```

---

<div align="center">
<sub>Universidad Camilo José Cela · Curso 2026/2027</sub>
</div>
