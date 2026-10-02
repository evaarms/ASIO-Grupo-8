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
| `I001` | **P1** · Instalación de Ubuntu Server en una máquina virtual | `I001-documentacion-ER` | 🟡 En revisión | [`P1/`](P1/) |

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

**Documentos entregados (2):** memoria y presentación, en [`P1/documentos/`](P1/documentos/). Los comandos utilizados están en [`P1/codigo/`](P1/codigo/).

---

## 📁 Estructura del repositorio

```
ASIO-Grupo-8/
├── README.md
├── .github/
│   ├── ISSUE_TEMPLATE/practica.yml     # Plantilla de issue (guía de la asignatura)
│   └── pull_request_template.md        # Plantilla de pull request
└── P1/
    ├── documentos/                     # Memoria y presentación (2 documentos)
    └── codigo/
        └── ASSIO_P1_comandos.txt       # Comandos utilizados en la práctica
```

---

## 🔀 Flujo de trabajo (guía GitHub de la asignatura)

1. **Issue por práctica**
   - ID: `Ixxx` (xxx = nº de issue). Ejemplo: `I001`.
   - Título: título de la práctica.
   - Descripción: tareas a realizar (lista de comprobación).
   - *Assignees*: **todos los integrantes del grupo**.
2. **Rama**: `<IdIssue>-documentacion-<Iniciales>`. Ejemplo: `I001-documentacion-ER`.
3. **Documentos**: 2 por práctica, la **presentación** y la **memoria**.
4. **Pull request** de la rama a `main`, que cierra la issue (`Closes #n`).
5. **Revisión**: máximo **2 revisiones** antes de fusionar.

```
issue I00x  ──►  rama I00x-documentacion-XX  ──►  commits  ──►  pull request  ──►  revisión (máx. 2)  ──►  main
```

### Convención de commits

```
I001: descripción breve del cambio
```

---

<div align="center">
<sub>Universidad Camilo José Cela · Curso 2026/2027</sub>
</div>
