#!/bin/bash

# This script cleans up unused MiSTer FPGA PC/Console game directories and their corresponding core files.
# It identifies directories in /media/fat/games that are empty or contain only one file.
# Upon finding such a directory, it prompts the user to confirm deletion of the directory
# and its associated core files located in /media/fat/_Computer or /media/fat/_Console.

GAMES_PATH="/media/fat/games"
CORE_PATHS="/media/fat/_Computer /media/fat/_Console"

# Core lookup map generated from 'Mister FPGA core names and directories.csv'
declare -A core_map
core_map["AcornAtom"]="AcornAtom"
core_map["AcornElectron"]="AcornElectron"
core_map["Adam"]="ColecoAdam"
core_map["AliceMC10"]="AliceMC10"
core_map["Altair8800"]="Altair8800"
core_map["Amiga"]="Amiga.mgl,Minimig"
core_map["Amiga500"]="Amiga 500.mgl"
core_map["AmigaCD32"]="Amiga CD32.mgl"
core_map["Amstrad"]="Amstrad"
core_map["Amstrad PCW"]="Amstrad-PCW"
core_map["AO486"]="ao486"
core_map["APOGEE"]="Apogee"
core_map["Apple-I"]="Apple-I"
core_map["Apple-II"]="Apple-II"
core_map["AQUARIUS"]="Aquarius"
core_map["Arcadia"]="Arcadia"
core_map["ARCHIE"]="Archie"
core_map["Astrocade"]="Astrocade"
core_map["ATARI2600"]="Atari 2600.mgl"
core_map["ATARI5200"]="Atari5200"
core_map["ATARI7800"]="Atari7800"
core_map["ATARI800"]="Atari800"
core_map["AtariLynx"]="AtariLynx"
core_map["AtariST"]="AtariST"
core_map["AVision"]="AdventureVision"
core_map["AY-3-8500"]="AY-3-8500"
core_map["BBCBridgeCompanion"]="BBCBridgeCompanion"
core_map["BBCMicro"]="BBCMicro"
core_map["BK0011M"]="BK0011M"
core_map["C128"]="C128"
core_map["C16"]="C16"
core_map["C64"]="C64"
core_map["Casio_PV-1000"]="Casio_PV-1000"
core_map["Casio_PV-2000"]="Casio_PV-2000"
core_map["ChannelF"]="ChannelF"
core_map["CoCo2"]="CoCo2"
core_map["COCO3"]="CoCo3"
core_map["Coleco"]="ColecoVision"
core_map["CreatiVision"]="CreatiVision"
core_map["EDSAC"]="EDSAC"
core_map["eg2000"]="eg2000"
core_map["Galaksija"]="Galaksija"
core_map["Gamate"]="Gamate"
core_map["GAMEBOY"]="Gameboy"
core_map["GAMEBOY2P"]="Gameboy2P"
core_map["GameGear"]="Game Gear.mgl"
core_map["GameNWatch"]="GnW"
core_map["GBA"]="GBA"
core_map["GBA2P"]="GBA2P"
core_map["GBC"]="GameboyColor.mgl"
core_map["Genesis"]="Genesis"
core_map["Homelab"]="Homelab"
core_map["Intellivision"]="Intellivision"
core_map["Interact"]="Interact"
core_map["Jupiter"]="Jupiter"
core_map["Laser"]="Laser310"
core_map["Lynx48"]="Lynx48"
core_map["MACPLUS"]="MacPlus"
core_map["MegaCD"]="MegaCD"
core_map["MegaDrive"]="MegaDrive"
core_map["MegaDuck"]="Mega Duck.mgl"
core_map["MSX"]="MSX"
core_map["MSX1"]="MSX1"
core_map["MultiComp"]="MultiComp"
core_map["MyVision"]="MyVision"
core_map["N64"]="N64,N64_80MHz"
core_map["NEOGEO"]="NeoGeo"
core_map["NeoGeoPocket"]="NeoGeoPocket"
core_map["NES"]="NES"
core_map["ODYSSEY2"]="Odyssey2"
core_map["Ondra_SPO186"]="Ondra_SPO186"
core_map["ORAO"]="ORAO"
core_map["Oric"]="Oric"
core_map["PC8801"]="PC88"
core_map["PCXT"]="PCXT"
core_map["PDP1"]="PDP1"
core_map["PET2001"]="PET2001"
core_map["PMD85"]="PMD85"
core_map["PocketChallengeV2"]="Pocket Challenge V2.mgl"
core_map["PokemonMini"]="PokemonMini"
core_map["PSX"]="PSX,PSX2XCPU"
core_map["QL"]="QL"
core_map["RX78"]="RX78"
core_map["S32X"]="S32X"
core_map["SAMCOUPE"]="SAMCoupe"
core_map["Saturn"]="Saturn"
core_map["SGB"]="SGB"
core_map["SHARP MZ SERIES"]="SharpMZ"
core_map["SharpMZ"]="SMS"
core_map["SMS"]="SNES"
core_map["SNES"]="SordM5"
core_map["Spectrum"]="ZX-Spectrum"
core_map["SPMX"]="Specialist"
core_map["SuperVision"]="SuperVision"
core_map["SuperVision8000"]="Super_Vision_8000"
core_map["SVI328"]="Svi328"
core_map["TatungEinstein"]="TatungEinstein"
core_map["TGFX16"]="TurboGrafx16"
core_map["TI-99_4A"]="Ti994a"
core_map["TomyTutor"]="TomyTutor"
core_map["TRS-80"]="TRS-80"
core_map["TSConf"]="TSConf"
core_map["UK101"]="UK101"
core_map["VC4000"]="VC4000"
core_map["VECTOR06"]="Vector-06C"
core_map["VECTREX"]="Vectrex"
core_map["VIC20"]="VIC20"
core_map["VT52"]="VT52"
core_map["WonderSwan"]="WonderSwan Color.mgl"
core_map["WonderSwanColor"]="WonderSwan"
core_map["X68000"]="X68000"
core_map["ZX81"]="ZX81"
core_map["ZXNext"]="ZXNext"

echo "Scanning for unused PC/Console game directories..."

for dir in "$GAMES_PATH"/*; do
    if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")
        file_count=$(find "$dir" -maxdepth 1 -type f | wc -l)

        if [ "$file_count" -le 1 ]; then
            echo "----------------------------------------------------"
            echo "Found potential unused directory: $dir ($file_count files)"

            # Check if the directory name exists in our core map
            if [[ -n "${core_map[$dir_name]}" ]]; then
                # Convert comma-separated string to bash array
                IFS=',' read -r -a core_bases_array <<< "${core_map[$dir_name]}"
                echo "Corresponding core(s) for '$dir_name': ${core_bases_array[*]}"
            else
                echo "No corresponding core found for '$dir_name' in the lookup table. Skipping this directory."
                continue
            fi

            read -p "Delete '$dir_name' and its associated core(s)? (y/s/c) [y=Yes, s=Skip, c=Cancel]: " -n 1 -r
            echo
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                echo "Deleting directory: $dir"
                if rm -rf "$dir"; then
                    echo "Successfully deleted directory: $dir"
                else
                    echo "ERROR: Failed to delete directory: $dir. Check permissions or if directory is in use."
                fi

                # Iterate through each base core name in the array
                for base_name in "${core_bases_array[@]}"; do
                    found_core_deleted=false
                    # Search for the core file in both _Computer and _Console paths
                    for core_path in $CORE_PATHS; do
                        # Check if the core name itself contains '.mgl'. If so, search for exact match.
                        # Otherwise, assume it's an .rbf base name and search with wildcard.
                        if [[ "$base_name" == *".mgl" ]]; then
                            find "$core_path" -maxdepth 1 -type f -name "$base_name" -print0 | while IFS= read -r -d $'\0' core_file; do
                                if [ -f "$core_file" ]; then
                                    echo "Attempting to delete core file: $core_file"
                                    if rm -f "$core_file"; then
                                        echo "Successfully deleted core file: $core_file"
                                        found_core_deleted=true
                                    else
                                        echo "ERROR: Failed to delete core file: $core_file. Check permissions or if file is in use."
                                    fi
                                fi
                            done
                        else
                            # For .rbf base names, search with wildcard for versioned files
                            find "$core_path" -maxdepth 1 -type f -name "$base_name*.rbf" -print0 | while IFS= read -r -d $'\0' core_file; do
                                if [ -f "$core_file" ]; then
                                    echo "Attempting to delete core file: $core_file"
                                    if rm -f "$core_file"; then
                                        echo "Successfully deleted core file: $core_file"
                                        found_core_deleted=true
                                    else
                                        echo "ERROR: Failed to delete core file: $core_file. Check permissions or if file is in use."
                                    fi
                                fi
                            done
                        fi
                    done
                    if [ "$found_core_deleted" = false ]; then
                        if [[ "$base_name" == *".mgl" ]]; then
                            echo "Warning: No core file matching '$base_name' found or deleted in $CORE_PATHS for '$dir_name'."
                        else
                            echo "Warning: No core file(s) matching '$base_name*.rbf' found or deleted in $CORE_PATHS for '$dir_name'."
                        fi
                    fi
                done
                echo "Deletion process for $dir_name finished."
            elif [[ "$REPLY" =~ ^[Ss]$ ]]; then
                echo "Skipping $dir_name."
            else
                echo "Operation cancelled by user."
                exit 0
            fi
            echo "----------------------------------------------------"
        fi
    fi
done

echo "Cleanup process finished."