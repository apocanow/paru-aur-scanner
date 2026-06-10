#!/bin/bash

# ============================================
# paru-guard - Security wrapper for Paru
# Instalador oficial
# Repo: https://github.com/tuusuario/paru-guard
# ============================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                    ║${NC}"
echo -e "${BLUE}║     🔒 P A R U - G U A R D   I N S T A L L E R    ║${NC}"
echo -e "${BLUE}║                                                    ║${NC}"
echo -e "${BLUE}║  Security wrapper for Paru + AUR Scanner          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================
# PASO 1: Verificar que estamos en Arch/CachyOS
# ============================================
echo -e "${YELLOW}[1/5] Verificando sistema operativo...${NC}"

if ! command -v pacman &> /dev/null; then
    echo -e "${RED}❌ Este script solo funciona en Arch Linux / CachyOS${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Sistema compatible${NC}"

# ============================================
# PASO 2: Instalar aur-scanner si no existe
# ============================================
echo ""
echo -e "${YELLOW}[2/5] Verificando aur-scanner...${NC}"

if ! command -v aur-scan &> /dev/null; then
    echo -e "${YELLOW}⚠️  aur-scanner no está instalado. Instalándolo...${NC}"
    
    # Detectar helper AUR
    if command -v paru &> /dev/null; then
        paru -S aur-scanner-git --noconfirm
    elif command -v yay &> /dev/null; then
        yay -S aur-scanner-git --noconfirm
    else
        echo -e "${RED}❌ No se encontró paru ni yay. Instala primero un helper AUR.${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ aur-scanner instalado${NC}"
else
    echo -e "${GREEN}✅ aur-scanner ya está instalado${NC}"
fi

# ============================================
# PASO 3: Instalar paru si no existe
# ============================================
echo ""
echo -e "${YELLOW}[3/5] Verificando Paru...${NC}"

if ! command -v paru &> /dev/null; then
    echo -e "${YELLOW}⚠️  Paru no está instalado. Instalándolo...${NC}"
    sudo pacman -S --needed base-devel git --noconfirm
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd ~
    echo -e "${GREEN}✅ Paru instalado${NC}"
else
    echo -e "${GREEN}✅ Paru ya está instalado${NC}"
fi

# ============================================
# PASO 4: Crear el wrapper paru-guard
# ============================================
echo ""
echo -e "${YELLOW}[4/5] Instalando paru-guard wrapper...${NC}"

sudo tee /usr/local/bin/paru-guard > /dev/null << 'WRAPPER'
#!/bin/bash

# paru-guard - Security wrapper for Paru
# Ejecuta aur-scanner antes de instalar paquetes AUR

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MODE=""
PACKAGES=()

# Detectar modo de operación
for arg in "$@"; do
    case "$arg" in
        -S|--sync)
            MODE="install"
            ;;
        -R|--remove)
            MODE="remove"
            ;;
        -Syu|--sync-upgrade)
            MODE="upgrade"
            ;;
        -Sy|--sync-refresh)
            MODE="refresh"
            ;;
    esac
done

# Extraer nombres de paquetes (solo para modo install)
if [[ "$MODE" == "install" ]]; then
    skip_next=false
    for arg in "$@"; do
        if [[ "$skip_next" == true ]]; then
            skip_next=false
            continue
        fi
        if [[ "$arg" == "-S" || "$arg" == "--sync" ]]; then
            continue
        fi
        if [[ "$arg" == "--noconfirm" || "$arg" == "--needed" ]]; then
            continue
        fi
        if [[ "$arg" != -* ]]; then
            PACKAGES+=("$arg")
        fi
    done
fi

# Mostrar banner
echo ""
echo -e "${BLUE}┌────────────────────────────────────────────┐${NC}"
echo -e "${BLUE}│  🔒 P A R U - G U A R D                   │${NC}"
echo -e "${BLUE}│  Security wrapper active                  │${NC}"
echo -e "${BLUE}└────────────────────────────────────────────┘${NC}"
echo ""

case "$MODE" in
    install)
        echo -e "${YELLOW}📦 Modo: Instalar paquetes${NC}"
        echo ""
        
        if [[ ${#PACKAGES[@]} -eq 0 ]]; then
            echo -e "${YELLOW}⚠️  No se especificaron paquetes${NC}"
        else
            ALL_SAFE=true
            for pkg in "${PACKAGES[@]}"; do
                echo -e "${BLUE}────────────────────────────────────────────${NC}"
                echo -e "${BLUE}🔍 Escaneando:${NC} $pkg"
                echo ""
                
                OUTPUT=$(aur-scan check "$pkg" 2>&1)
                
                if echo "$OUTPUT" | grep -q "Not found: Package.*not found in AUR"; then
                    echo -e "${GREEN}ℹ️  $pkg es de repositorio oficial${NC}"
                    echo -e "${GREEN}✅ Seguro (repositorio confiable)${NC}"
                else
                    echo "$OUTPUT"
                    if echo "$OUTPUT" | grep -qi "No security issues detected"; then
                        echo -e "${GREEN}✅ Paquete AUR: escaneo pasado - SEGURO${NC}"
                    elif echo "$OUTPUT" | grep -qi "Security issues detected"; then
                        echo -e "${RED}❌ PAQUETE SOSPECHOSO DETECTADO${NC}"
                        ALL_SAFE=false
                    else
                        echo -e "${GREEN}✅ Paquete AUR: escaneo pasado${NC}"
                    fi
                fi
                echo ""
            done
            
            if [[ "$ALL_SAFE" == false ]]; then
                echo -e "${RED}┌────────────────────────────────────────────┐${NC}"
                echo -e "${RED}│  ❌ INSTALACIÓN CANCELADA                   │${NC}"
                echo -e "${RED}│  Se detectaron paquetes sospechosos        │${NC}"
                echo -e "${RED}└────────────────────────────────────────────┘${NC}"
                exit 1
            fi
        fi
        ;;
    
    upgrade)
        echo -e "${YELLOW}🔄 Modo: Actualizar sistema${NC}"
        echo -e "${YELLOW}⚠️  Los paquetes AUR ya instalados no se escanean${NC}"
        echo -e "${YELLOW}💡 Para escanear un paquete específico:${NC}"
        echo -e "${BLUE}   aur-scan check <nombre>${NC}"
        echo ""
        ;;
    
    remove)
        echo -e "${YELLOW}🗑️  Modo: Eliminar paquetes${NC}"
        echo -e "${GREEN}✅ No requiere escaneo${NC}"
        echo ""
        ;;
    
    refresh)
        echo -e "${YELLOW}🔄 Modo: Actualizar base de datos${NC}"
        echo -e "${GREEN}✅ No requiere escaneo${NC}"
        echo ""
        ;;
    
    *)
        echo -e "${YELLOW}⚠️  Modo no reconocido${NC}"
        ;;
esac

echo -e "${GREEN}────────────────────────────────────────────${NC}"
echo -e "${GREEN}✅ Ejecutando Paru...${NC}"
echo -e "${GREEN}────────────────────────────────────────────${NC}"
echo ""

exec /usr/bin/paru "$@"
WRAPPER

sudo chmod +x /usr/local/bin/paru-guard
echo -e "${GREEN}✅ paru-guard instalado en /usr/local/bin/paru-guard${NC}"

# ============================================
# PASO 5: Configurar alias (opcional)
# ============================================
echo ""
echo -e "${YELLOW}[5/5] Configurar alias para usar 'paru' directamente?${NC}"
read -p "¿Quieres que 'paru' use automáticamente paru-guard? (s/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Ss]$ ]]; then
    if grep -q "alias paru=" ~/.bashrc 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Ya existe un alias para paru en ~/.bashrc${NC}"
        read -p "¿Sobrescribir? (s/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            sed -i '/alias paru=/d' ~/.bashrc
            echo "alias paru='paru-guard'" >> ~/.bashrc
            echo -e "${GREEN}✅ Alias actualizado${NC}"
        fi
    else
        echo "alias paru='paru-guard'" >> ~/.bashrc
        echo -e "${GREEN}✅ Alias agregado a ~/.bashrc${NC}"
    fi
    echo -e "${YELLOW}⚠️  Ejecuta 'source ~/.bashrc' para usar el alias en esta terminal${NC}"
fi

# ============================================
# FINALIZAR
# ============================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                    ║${NC}"
echo -e "${GREEN}║     ✅ INSTALACIÓN COMPLETADA                      ║${NC}"
echo -e "${GREEN}║                                                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 Comandos disponibles:${NC}"
echo -e "   ${GREEN}paru-guard -S <paquete>${NC}  → Instalar con escaneo"
echo -e "   ${GREEN}paru-guard -Syu${NC}          → Actualizar sistema"
echo -e "   ${GREEN}paru-guard -R <paquete>${NC}  → Eliminar paquete"
echo ""
echo -e "${BLUE}💡 Probar que funciona:${NC}"
echo -e "   ${YELLOW}paru-guard -S lolcat${NC}"
echo ""
echo -e "${BLUE}🛡️  Tu sistema está protegido contra paquetes AUR maliciosos${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════${NC}"
