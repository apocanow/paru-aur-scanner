# paru-aur-scanner

🔒 Security wrapper for Paru with AUR package scanning capabilities.

**Versiones:** [English](#english) | [Español](#español)

---

## English

### Overview

**paru-aur-scanner** is a security-focused project that provides tools to safely manage AUR (Arch User Repository) packages on Arch Linux and CachyOS systems. It includes:

- **paru-guard**: A secure wrapper for Paru that scans packages before installation
- **install-paru-guard.sh**: Automated installer for setting up the security wrapper
- **paru-aur**: A lightweight package security wrapper script

### Why Use This?

The AUR is a community-driven repository where anyone can contribute packages. While most packages are safe, malicious or poorly maintained packages can pose security risks. This tool:

✅ Scans packages before installation  
✅ Checks for known security issues  
✅ Prevents installation of suspicious packages  
✅ Works with both official and AUR repositories  
✅ Provides clear security feedback  

### Features

- **Automatic package scanning** before installation
- **aur-scanner integration** for security analysis
- **Colored output** for easy status identification
- **Support for common Paru operations**: install (-S), remove (-R), upgrade (-Syu), refresh (-Sy)
- **Optional shell alias** for seamless integration
- **Installation verification** of dependencies

### Requirements

- Arch Linux or CachyOS system
- `pacman` package manager
- `git` for building packages
- `base-devel` group (for compiling)
- `paru` AUR helper (installed if missing)
- `aur-scanner` tool (installed if missing)

### Installation

#### Quick Install

```bash
git clone https://github.com/apocanow/paru-aur-scanner.git
cd paru-aur-scanner
chmod +x install-paru-guard.sh
./install-paru-guard.sh
```

The installer will:
1. ✅ Verify your system (Arch/CachyOS)
2. ✅ Install `aur-scanner` if needed
3. ✅ Install `paru` if needed
4. ✅ Install `paru-guard` wrapper to `/usr/local/bin/paru-guard`
5. ✅ Optionally configure an alias for `paru`

#### Manual Installation

```bash
# Copy the wrapper script
sudo cp paru-aur /usr/local/bin/paru-guard
sudo chmod +x /usr/local/bin/paru-guard

# Or use paru-guard name directly
sudo cp paru-aur /usr/local/bin/paru-aur
sudo chmod +x /usr/local/bin/paru-aur
```

### Usage

#### Basic Commands

```bash
# Install a package with security scan
paru-guard -S <package_name>

# Install multiple packages
paru-guard -S package1 package2 package3

# Update system
paru-guard -Syu

# Remove a package
paru-guard -R <package_name>

# Refresh package database
paru-guard -Sy
```

#### Examples

```bash
# Safe installation
$ paru-guard -S lolcat
╔══════════════════════════════════════╗
║     🔒 PARU-AUR SECURITY WRAPPER    ║
╚══════════════════════════════════════╝

📦 Modo: INSTALAR PAQUETES

────────────────────────────────────────
🔍 Escaneando: lolcat

ℹ️  lolcat es de repositorio oficial
✅ Seguro (repositorio confiable)

# Suspicious package detected
$ paru-guard -S suspicious-package
❌ PAQUETE SOSPECHOSO DETECTADO
╔══════════════════════════════════════╗
║  ❌ INSTALACIÓN CANCELADA            ║
║  Se detectaron paquetes sospechosos  ║
╚══════════════════════════════════════╝
```

#### With Shell Alias

If you configured the alias during installation:

```bash
# Works exactly like paru but with security wrapper
paru -S <package_name>
```

### How It Works

1. **Detects operation mode**: install (-S), remove (-R), upgrade (-Syu), refresh (-Sy)
2. **Extracts package names** from command arguments
3. **For installation mode**:
   - Scans each package using `aur-scan check <package>`
   - Checks for official repository packages (safe by default)
   - Analyzes AUR packages for security issues
4. **Blocks installation** if any package is flagged as suspicious
5. **Proceeds with installation** if all checks pass

### Output Meanings

| Symbol | Meaning | Action |
|--------|---------|--------|
| ✅ | Package is safe | Continues normally |
| ❌ | Security issues detected | Installation blocked |
| ⚠️  | Warning or information | Review the message |
| 🔍 | Scanning in progress | Wait for scan results |

### File Structure

```
paru-aur-scanner/
├── README.md                    # Documentation
├── install-paru-guard.sh        # Installer script
├── paru-aur                     # Security wrapper
└── LICENSE                      # License (optional)
```

### Troubleshooting

#### `aur-scan: command not found`

The installer should handle this, but if you encounter it:

```bash
# Install manually
paru -S aur-scanner-git
# Or use yay
yay -S aur-scanner-git
```

#### `paru: command not found`

The installer should handle this, but if you encounter it:

```bash
# Install manually
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si
```

#### Alias not working

If you configured the alias but it's not working:

```bash
# Reload bash configuration
source ~/.bashrc

# Or add manually
echo "alias paru='paru-guard'" >> ~/.bashrc
source ~/.bashrc
```

### Performance Notes

- 🚀 First-time installation takes 2-5 minutes
- ⚡ Regular package scans are very fast (< 1 second per package)
- 💾 Minimal disk space required (~50MB for dependencies)

### Security Best Practices

1. **Always review** installation results before confirming
2. **Keep paru updated**: `paru -Syu`
3. **Keep aur-scanner updated**: `paru -S aur-scanner-git`
4. **Research packages** if unsure about results
5. **Check the official AUR website** for package details: https://aur.archlinux.org/

### License

This project is provided as-is for educational and personal use.

### Contributing

Found an issue? Have suggestions? Consider:
- Testing the scripts
- Reporting bugs
- Suggesting improvements
- Sharing your experience

### Disclaimer

This tool provides an extra security layer but is **not a complete guarantee** against all threats. Always exercise caution when installing packages from the AUR and research packages when in doubt.

---

## Español

### Descripción General

**paru-aur-scanner** es un proyecto enfocado en seguridad que proporciona herramientas para gestionar de forma segura paquetes de AUR (Arch User Repository) en sistemas Arch Linux y CachyOS. Incluye:

- **paru-guard**: Un envoltorio seguro para Paru que escanea paquetes antes de instalarlos
- **install-paru-guard.sh**: Instalador automatizado para configurar el envoltorio de seguridad
- **paru-aur**: Un script ligero de envoltorio de seguridad para paquetes

### ¿Por Qué Usar Esto?

El AUR es un repositorio impulsado por la comunidad donde cualquiera puede contribuir paquetes. Aunque la mayoría son seguros, los paquetes maliciosos o mal mantenidos pueden representar riesgos de seguridad. Esta herramienta:

✅ Escanea paquetes antes de instalar  
✅ Verifica problemas de seguridad conocidos  
✅ Previene la instalación de paquetes sospechosos  
✅ Funciona con repositorios oficiales y AUR  
✅ Proporciona retroalimentación clara de seguridad  

### Características

- **Escaneo automático de paquetes** antes de la instalación
- **Integración con aur-scanner** para análisis de seguridad
- **Salida con colores** para fácil identificación de estado
- **Soporte para operaciones comunes de Paru**: instalar (-S), eliminar (-R), actualizar (-Syu), actualizar BD (-Sy)
- **Alias de shell opcional** para integración sin problemas
- **Verificación de instalación** de dependencias

### Requisitos

- Sistema Arch Linux o CachyOS
- Gestor de paquetes `pacman`
- `git` para compilar paquetes
- Grupo `base-devel` (para compilación)
- `paru` helper de AUR (se instala si falta)
- Herramienta `aur-scanner` (se instala si falta)

### Instalación

#### Instalación Rápida

```bash
git clone https://github.com/apocanow/paru-aur-scanner.git
cd paru-aur-scanner
chmod +x install-paru-guard.sh
./install-paru-guard.sh
```

El instalador hará lo siguiente:
1. ✅ Verificar tu sistema (Arch/CachyOS)
2. ✅ Instalar `aur-scanner` si es necesario
3. ✅ Instalar `paru` si es necesario
4. ✅ Instalar `paru-guard` en `/usr/local/bin/paru-guard`
5. ✅ Opcionalmente configurar un alias para `paru`

#### Instalación Manual

```bash
# Copiar el script del envoltorio
sudo cp paru-aur /usr/local/bin/paru-guard
sudo chmod +x /usr/local/bin/paru-guard

# O usar nombre paru-guard directamente
sudo cp paru-aur /usr/local/bin/paru-aur
sudo chmod +x /usr/local/bin/paru-aur
```

### Uso

#### Comandos Básicos

```bash
# Instalar un paquete con escaneo de seguridad
paru-guard -S <nombre_paquete>

# Instalar múltiples paquetes
paru-guard -S paquete1 paquete2 paquete3

# Actualizar sistema
paru-guard -Syu

# Eliminar un paquete
paru-guard -R <nombre_paquete>

# Actualizar base de datos de paquetes
paru-guard -Sy
```

#### Ejemplos

```bash
# Instalación segura
$ paru-guard -S lolcat
╔══════════════════════════════════════╗
║     🔒 PARU-AUR SECURITY WRAPPER    ║
╚══════════════════════════════════════╝

📦 Modo: INSTALAR PAQUETES

────────────────────────────────────────
🔍 Escaneando: lolcat

ℹ️  lolcat es de repositorio oficial
✅ Seguro (repositorio confiable)

# Paquete sospechoso detectado
$ paru-guard -S paquete-sospechoso
❌ PAQUETE SOSPECHOSO DETECTADO
╔══════════════════════════════════════╗
║  ❌ INSTALACIÓN CANCELADA            ║
║  Se detectaron paquetes sospechosos  ║
╚══════════════════════════════════════╝
```

#### Con Alias de Shell

Si configuraste el alias durante la instalación:

```bash
# Funciona exactamente como paru pero con envoltorio de seguridad
paru -S <nombre_paquete>
```

### Cómo Funciona

1. **Detecta modo de operación**: instalar (-S), eliminar (-R), actualizar (-Syu), actualizar BD (-Sy)
2. **Extrae nombres de paquetes** de los argumentos del comando
3. **Para modo instalación**:
   - Escanea cada paquete usando `aur-scan check <paquete>`
   - Verifica paquetes de repositorio oficial (seguros por defecto)
   - Analiza paquetes AUR buscando problemas de seguridad
4. **Bloquea la instalación** si algún paquete se marca como sospechoso
5. **Procede con la instalación** si todos los verificaciones pasan

### Significado de Salida

| Símbolo | Significado | Acción |
|---------|-------------|--------|
| ✅ | Paquete es seguro | Continúa normalmente |
| ❌ | Problemas de seguridad detectados | Instalación bloqueada |
| ⚠️  | Advertencia o información | Revisa el mensaje |
| 🔍 | Escaneo en progreso | Espera resultados del escaneo |

### Estructura de Archivos

```
paru-aur-scanner/
├── README.md                    # Documentación
├── install-paru-guard.sh        # Script de instalación
├── paru-aur                     # Envoltorio de seguridad
└── LICENSE                      # Licencia (opcional)
```

### Solución de Problemas

#### `aur-scan: comando no encontrado`

El instalador debería manejar esto, pero si lo encuentras:

```bash
# Instalar manualmente
paru -S aur-scanner-git
# O usar yay
yay -S aur-scanner-git
```

#### `paru: comando no encontrado`

El instalador debería manejar esto, pero si lo encuentras:

```bash
# Instalar manualmente
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git /tmp/paru
cd /tmp/paru
makepkg -si
```

#### El alias no funciona

Si configuraste el alias pero no funciona:

```bash
# Recargar configuración de bash
source ~/.bashrc

# O agregar manualmente
echo "alias paru='paru-guard'" >> ~/.bashrc
source ~/.bashrc
```

### Notas de Rendimiento

- 🚀 La primera instalación toma 2-5 minutos
- ⚡ Los escaneos regulares de paquetes son muy rápidos (< 1 segundo por paquete)
- 💾 Espacio en disco mínimo requerido (~50MB para dependencias)

### Mejores Prácticas de Seguridad

1. **Siempre revisa** los resultados de instalación antes de confirmar
2. **Mantén paru actualizado**: `paru -Syu`
3. **Mantén aur-scanner actualizado**: `paru -S aur-scanner-git`
4. **Investiga paquetes** si tienes dudas sobre los resultados
5. **Verifica el sitio web oficial de AUR** para detalles del paquete: https://aur.archlinux.org/

### Licencia

Este proyecto se proporciona tal cual para uso educativo y personal.

### Contribuciones

¿Encontraste un problema? ¿Tienes sugerencias? Considera:
- Probar los scripts
- Reportar errores
- Sugerir mejoras
- Compartir tu experiencia

### Descargo de Responsabilidad

Esta herramienta proporciona una capa extra de seguridad pero **no es una garantía completa** contra todas las amenazas. Siempre actúa con cautela al instalar paquetes de AUR e investiga paquetes cuando tengas dudas.
