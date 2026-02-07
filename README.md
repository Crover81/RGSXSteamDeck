# 🎮 Retro Game Sets Xtra (RGSX) For Steam Deck

A free, user-friendly ROM downloader for Batocera, Knulli, and RetroBat with multi-source support.

This is an unofficial "One-Line" installer. It handles all the heavy lifting: downloads the latest RGSX version, sets up an isolated Python environment, and preps everything for Steam Gaming Mode.

📂 Where to install

The script must be executed inside your roms folder, for example:

<pre>EmuDeck (Internal): Home -> Emulation -> roms
EmuDeck (SD Card): Primary (or SD name) -> Emulation -> roms
RetroDeck: Home -> retrodeck -> roms</pre> 

⚠️ Technical Note: Why not in the "ports" folder?

The installation goes into roms/RGSX instead of roms/ports. This is a technical choice. Due to SteamOS file system structure and permission handling, frontends (like EmulationStation) often fail to launch the .sh script correctly, as they lack the proper execution context to manage the Python environment. This installer sets everything up for a direct launch via Steam Gaming Mode, ensuring the script runs with the correct user permissions.

🐧 Compatibility
Tested on SteamOS (Steam Deck). It should also work on other SteamOS-based distros like Bazzite or ChimeraOS.

📝 How to Install (3 Steps)

Switch to Desktop Mode.
Open your roms folder, Right-Click -> Open Terminal Here.
Copy and paste this command, then press Enter:

<pre>curl -L -s "https://tinyurl.com/rgsxsteamdeck" | bash</pre>

⚙️ What does this command do?

Safety Check: Verifies you are inside the roms folder.
Python Sandboxing: Creates a local virtual environment (venv), installing necessary libraries (Pygame, Pillow) only inside the RGSX folder, keeping your OS clean.
Steam Assets: Downloads icons and cover art ready for Steam.
Launcher: Generates RGSX_Deck.sh optimized for Gaming Mode.

🛑 Disclaimer & Support

This script is merely an installation tool. For bugs or errors within the RGSX software itself, please report them to the original author on GitHub. Do not report software bugs to the creator of this installer script.
