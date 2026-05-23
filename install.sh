#!/usr/bin/env bash
# ==============================================================================
# nscan — installer
# Copia el binario a /usr/local/bin/nscan y configura permisos.
# Requiere root porque /usr/local/bin es propiedad de root.
# Uso:  sudo ./install.sh
# ==============================================================================

set -e

# ── Colores ───────────────────────────────────────────────────────────────────
RED='\033[1;31m'
GREEN='\033[1;32m'
GRAY='\033[0;90m'
WHITE='\033[1;37m'
NC='\033[0m'

# ── Banner ────────────────────────────────────────────────────────────────────
printf "\n"
printf "${RED}      ███╗   ██╗ ███████╗  ██████╗  █████╗  ███╗   ██╗${NC}\n"
printf "${RED}      ████╗  ██║ ██╔════╝ ██╔════╝ ██╔══██╗ ████╗  ██║${NC}\n"
printf "${RED}      ██╔██╗ ██║ ███████╗ ██║      ███████║ ██╔██╗ ██║${NC}\n"
printf "${RED}      ██║╚██╗██║ ╚════██║ ██║      ██╔══██║ ██║╚██╗██║${NC}\n"
printf "${RED}      ██║ ╚████║ ███████║ ╚██████╗ ██║  ██║ ██║ ╚████║${NC}\n"
printf "${RED}      ╚═╝  ╚═══╝ ╚══════╝  ╚═════╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝${NC}\n"
printf "\n"
printf "${GRAY}      ────────────────────────────────────────────────${NC}\n"
printf "${WHITE}                       Installer${NC}\n"
printf "${GRAY}            Reconocimiento activo de infraestructura${NC}\n"
printf "${GRAY}      ────────────────────────────────────────────────${NC}\n\n"

# ── Root check ────────────────────────────────────────────────────────────────
if [ "$(id -u)" -ne 0 ]; then
    printf "${RED}[-] Se requieren privilegios root para escribir en /usr/local/bin.${NC}\n"
    printf "    ${GRAY}Ejecuta:${NC} ${WHITE}sudo ./install.sh${NC}\n\n"
    exit 1
fi

# ── Localizar el script fuente ────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/nscan"
TARGET="/usr/local/bin/nscan"

if [ ! -f "$SOURCE" ]; then
    printf "${RED}[-] No se encontró '${SOURCE}'.${NC}\n"
    printf "    ${GRAY}Asegúrate de ejecutar install.sh desde el directorio del repo.${NC}\n\n"
    exit 1
fi

# ── Verificar sintaxis del script ─────────────────────────────────────────────
printf "${GRAY}[~] Verificando sintaxis de nscan...${NC}\n"
if ! bash -n "$SOURCE" 2>/dev/null; then
    printf "${RED}[-] El script nscan tiene errores de sintaxis. Abortando.${NC}\n\n"
    exit 1
fi
printf "${GREEN}[+] Sintaxis OK.${NC}\n"

# ── Instalar ──────────────────────────────────────────────────────────────────
printf "${GRAY}[~] Copiando a ${TARGET}...${NC}\n"
install -m 755 -o root -g root "$SOURCE" "$TARGET"
printf "${GREEN}[+] Instalado en ${TARGET}${NC}\n"

# ── Verificar instalación ─────────────────────────────────────────────────────
if ! command -v nscan >/dev/null 2>&1; then
    printf "${RED}[-] nscan no está accesible desde el PATH.${NC}\n"
    printf "    ${GRAY}Verifica que /usr/local/bin esté en \$PATH.${NC}\n\n"
    exit 1
fi

INSTALLED_PATH="$(command -v nscan)"
printf "${GREEN}[+] Verificación OK:${NC} ${WHITE}${INSTALLED_PATH}${NC}\n\n"

# ── Mensaje final ─────────────────────────────────────────────────────────────
printf "${WHITE}Ya puedes usar nscan:${NC}\n"
printf "    ${GRAY}sudo nscan -r <IP|CIDR>${NC}          ${GRAY}# scan básico${NC}\n"
printf "    ${GRAY}sudo nscan -r <IP> -v fast -c${NC}     ${GRAY}# rápido + mostrar comandos${NC}\n"
printf "    ${GRAY}sudo nscan -h${NC}                     ${GRAY}# ayuda completa${NC}\n\n"

printf "${GRAY}La primera ejecución instalará automáticamente las dependencias${NC}\n"
printf "${GRAY}(nmap, exploitdb, vulscan, traceroute, bind9-dnsutils, jq, git).${NC}\n\n"
