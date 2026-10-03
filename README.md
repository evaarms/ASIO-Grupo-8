<div align="center">

# ASIO · Grupo 8

**Administración y Servicios de Sistemas Operativos (88020)**
Grado en Inteligencia Artificial y Robótica · Universidad Camilo José Cela

![Asignatura](https://img.shields.io/badge/asignatura-ASIO%2088020-872046)
![Prácticas](https://img.shields.io/badge/pr%C3%A1cticas-1%20en%20curso-872046)
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
| [`I001`](../../issues/1) | **P1** · Instalación de Ubuntu Server en una máquina virtual | `I001_Documentacion_ERJ` · `I001_Presentacion_ERJ` · `I001_Codigo_ERJ` · `I001_Anexos_ERJ` | 🟡 En curso | [`Practica_1/`](Practica_1/) |

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

## 📁 Estructura del repositorio

```
ASIO-Grupo-8/
├── README.md
└── Practica_1/
    ├── Documentacion/
    │   └── 88020_P1_Documentacion_AGJCER.pdf # Memoria del grupo (rama I001_Documentacion_ERJ)
    ├── Presentacion/
    │   └── 88020_P1_Presentacion_AGJCER.pdf  # Diapositivas (rama I001_Presentacion_ERJ)
    ├── Codigo/
    │   └── 88020_P1_Comandos_AGJCER.txt      # Comandos utilizados (rama I001_Codigo_ERJ)
    └── Anexos/
        ├── 88020_P1_Enunciado_AGJCER.pdf     # Enunciado del profesor (rama I001_Anexos_ERJ)
        └── 88020_P1_Guion_AGJCER.pdf         # Guion de la presentación
```
---

## 🔀 Flujo de trabajo (guía GitHub de la asignatura)

1. **Issue por práctica**
   - ID: `Ixxx` (xxx = nº de issue). Ejemplo: `I001`.
   - Título: título de la práctica.
   - Descripción: tareas a realizar (lista de comprobación).
   - *Assignees*: **todos los integrantes del grupo**.
2. **Ramas** (una por tipo de tarea): `<IdIssue>_<Tipo>_<Iniciales>`. Ejemplo: `I001_Documentacion_ERJ`, `I001_Presentacion_ERJ`, `I001_Codigo_ERJ`, `I001_Anexos_ERJ`.
3. **Documentos**: la **memoria** y la **presentación** (más código y anexos), dentro de la carpeta de la práctica.
4. **Pull request** de cada rama a `main`, titulada como la issue + tipo (p. ej. `I001 - P1: … - Documentación`), con su etiqueta: `documentation`, `presentación`, `código` o `anexos`.
5. **Revisión**: máximo **2 revisiones** antes de fusionar.

```
issue I00x  ──►  ramas I00x_<Tipo>_XXX  ──►  commits  ──►  pull request  ──►  revisión (máx. 2)  ──►  main
```

### Nombre de los documentos

```
88020_P1_<Titulo>_AGJCER.<ext>     # Titulo = Documentacion, Presentacion, Guion, Comandos o Enunciado
```

### Convención de commits

```
I001: descripción breve del cambio
```

---

<div align="center">
<sub>Universidad Camilo José Cela · Curso 2026/2027</sub>
</div>
