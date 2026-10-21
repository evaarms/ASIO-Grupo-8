# ASSIO-Grupo-8
# P1 - Instalación de Ubuntu Server en una Máquina Virtual

## Integrantes

* Alberto García Martín
* Javier Jiahao Cheng Hu
* Eva María Ramos Juárez
  
## Descripción

En esta práctica se ha realizado la **instalación y configuración de Ubuntu Server en una máquina virtual**.

Durante la práctica se han llevado a cabo las siguientes tareas:

* Creación y configuración de la máquina virtual.
* Configuración de la imagen ISO y del orden de arranque.
* Configuración de la red mediante **NAT**.
* Instalación de Ubuntu Server y configuración inicial.
* Configuración de las particiones del sistema.
* Creación del usuario administrador y configuración del **hostname**.
* Instalación y activación de **OpenSSH Server**.

El objetivo de la práctica ha sido familiarizarse con la **instalación y configuración básica de un servidor Ubuntu en un entorno virtualizado**.


# P2 - Sistema de archivos, comandos, usuarios y permisos

## Descripción

En esta práctica se ha preparado el servidor `server-asio-01` (Ubuntu Server 26.04.1 LTS) para el proyecto ficticio **AURORA-6** de AURORA Aerospace:

* Estructura del proyecto en `/srv/aurora6` por departamentos.
* Grupos `mecanica`, `avionica`, `software`, `compras` y `proyecto`, y cuentas de los responsables (miembros A, B y C) con contraseña temporal.
* Permisos **DAC** (751 en `documentacion`) y política por roles con **ACL**, bit **setgid** y ACL por defecto.
* Validación individual de cada usuario y matriz de accesos.
* Extras: sticky bit en `intercambio`, copia y restauración de permisos, `/etc/skel`, política de contraseñas, cuenta temporal `becario`, auditoría, cuenta de dirección `director` y acceso remoto por **SSH**.

## Documentos

| Documento | Ruta |
|---|---|
| Memoria | `Practica_2/Documentacion/88020_P2_Memoria_AGJCER.pdf` |
| Presentación | `Practica_2/Presentacion/88020_P2_Presentacion_AGJCER.pdf` |
| Guion de la presentación | `Practica_2/Anexos/88020_P2_Guion_AGJCER.pdf` |
| Enunciado | `Practica_2/Anexos/88020_P2_Enunciado_AGJCER.pdf` |
| Script y comandos | rama `I002_Codigo_ERJ`, carpeta `Practica_2/Codigo` |
