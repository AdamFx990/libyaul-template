#!/bin/sh

# Reset normal style
NORM="\033[0m"

# Font styles
BOLD="\033[1m"
DIM="\033[2m"
ULIN="\033[4m" # Underlined
INVR="\033[7m" # Inverted
HIDN="\033[8m" # Hidden
# Reset font styles
N_BOLD="\033[21m"
N_DIM="\033[22m"
N_ULIN="\033[24m" # Not underlined

# Font colours
DFT="\033[39m" # Default foreground colour
BLK="\033[30m" # Black
RED="\033[31m"
GRN="\033[32m" # Green
YLW="\033[33m" # Yellow
BLU="\033[34m" # Blue
MAG="\033[35m" # Magenta
CYN="\033[36m" # Cyan
GRY="\033[90m" # Grey
WIT="\033[97m" # White
# Light font colours
L_GRY="\033[37m" # Light grey
L_RED="\033[91m" # Light red
L_GRN="\033[92m" # Light green
L_YLW="\033[93m" # Light yellow
L_BLU="\033[94m" # Light blue
L_MAG="\033[95m" # Light magenta
L_CYN="\033[96m" # Light cyan

# Presets
P_ERR="${BOLD}${RED}"
P_INF="${ULIN}${CYN}"
P_WRN="${ULIN}${YLW}"
P_SCC="${BOLD}${GRN}"

# Name of current directory
DIR_NAME=${PWD##*/}
