#!/bin/sh

source scripts/config.sh

build() {
    CORES=$(nproc)
    
    echo -e "\n\n${GRN}Building ${P_INF}${DIR_NAME}${NORM} using ${P_INF}$CORES${NORM} CPU threads...\n"
    
    make -j${nproc-1} all
    
    if [ $? -ne 0 ]; then
        error_report "build failed!" 2
    fi
}

burn() {
    target_search
    
    echo -e "\n\n${GRN}Attempting to burn ${P_INF}${TARGET}${N_ULIN}${GRN}...${NORM}\n"
    
    sudo cdrdao write --speed 2 --eject "${TARGET}"
    
    if [ $? -ne 0 ]; then
        error_report "burn failed!" 200
    fi
}

check_if_installed() {
    EMU=$1
    command -v ${EMU} >/dev/null 2>&1 || {
        error_report "${P_INF}${EMU}${NORM} doesn't appear to be installed." 3
    }
}

clean() {
    echo -e "\n\n${P_INF}Cleaning build files...${NORM}\n"
    
    rm -f ./joengine/engine/*.o
    rm -f ./cd/0.bin
    rm -f *.o
    rm -f ./*.bin
    rm -f ./*.coff
    rm -f ./*.map
    rm -f ./*.iso
    
    make clean
}

error_report() {
    MSG=$1
    CODE=${2-1} # Code 1 if unspecified
    
    echo -e "\n\n${P_ERR}ERROR: \t${MSG}"
    echo -e "\t${L_RED}Aborting!${NORM}\n"
    
    exit $CODE
}

target_search() {
    # If a target hasn't been specified...
    LEN=${#TARGET}
    if [[ $LEN -eq 0 ]]; then
        # Try to find the target automatically
        LEN=${DISC_FORMAT#}
        if [[ $LEN -gt 0 ]]; then
            echo -e "Attempting to find a valid ${P_WRN}${DISC_FORMAT}${NORM} file..."
            TARGET=$(ls *.$DISC_FORMAT)
        else
            echo -e "${P_INF}No target or format specifed.${NORM} Attempting to find a valid target..."
            DISC_FORMATS="cue iso mds img"
            
            for FORMAT in ${DISC_FORMATS}; do
                echo -e "Searching for a ${P_INF}$FORMAT${NORM} in ${P_INF}${PWD}${NORM}"
                TARGET=$(ls *.$FORMAT)

                if [[ -f "${TARGET}" ]]; then
                    break
                fi
            done
        fi
    fi
    if [[ -f "${TARGET}" ]]; then
        echo -e "${P_SCC}Found '${ULIN}${TARGET}${N_ULIN}'${NORM}"
    else
        error_report "No valid target could be found. Did the build fail?" 4
    fi
}




run_emu() {
    EMU=$1
    
    target_search

    echo -e "\n\n${GRN}Attempting to run using ${P_INF}${EMU}${N_ULIN}${GRN}...${NORM}\n"
    
    check_if_installed $EMU
    
    case $EMU in
        yabause)
            yabause -a -i "$TARGET"
        ;;
        
        retroarch)
            retroarch -L /usr/lib/libretro/yabause_libretro.so "$TARGET"
        ;;
        
        *)
            $EMU "$TARGET"
        ;;
    esac
    
    exit $?
}

BUILD=false
BURN=false
CLEAN=false
EMU="retroarch"
RUN=false
WIPE=false

while [[ $# -gt 0 ]]; do
    # If a directory is specified, run the script there.
    if [[ -d $1 ]]; then
        START_DIR=${PWD}
        cd $1
        shift
    else
        case $1 in
            -b | --build)
                BUILD=true
                shift
            ;;
            
            --burn | --write)
                BURN=true;
                shift
            ;;
            
            -c | --clean)
                CLEAN=true
                shift
            ;;
            
            -e | --emulator)
                EMU="$2"
                RUN=true
                shift
                shift
            ;;
            
            -f | --format)
                # Trim a dot if the user added one
                DISC_FORMAT=$(echo "$2" | tr -d .)
                shift
            ;;
            
            -r | --run)
                RUN=true
                shift
            ;;
            
            -t | --target)
                TARGET="$2"
                shift
            ;;

            -w | --wipe)
                WIPE=true
                shift
            ;;
            
            -[bc][bc])
                CLEAN=true
                BUILD=true
                shift
            ;;
            
            -[br][br])
                BUILD=true
                RUN=true
                shift
            ;;
            
            -[bcr][bcr][bcr])
                CLEAN=true
                BUILD=true
                RUN=true
                shift
            ;;
            
            *)  shift;;
        esac
    fi
done

# Clear the terminal
if [ "$WIPE" = true ]; then
    clear
fi

# Delete previous build(s)
if [ "$CLEAN" = true ]; then
    clean
fi

# Build
if [ "$BUILD" = true ]; then
    build
fi

# Run
if [ "$RUN" = true ]; then
    run_emu $EMU
fi

# Burn
if [ "$BURN" = true ]; then
    burn
fi

cd $START_DIR

exit 0
