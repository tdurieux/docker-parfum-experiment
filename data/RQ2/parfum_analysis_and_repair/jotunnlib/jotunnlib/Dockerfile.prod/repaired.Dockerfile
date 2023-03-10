# Pull latest Ubuntu latest
FROM cm2network/steamcmd:latest

USER root

# Set working directory
WORKDIR /build

# Setup SteamCMD
RUN apt update \
    && apt install --no-install-recommends --yes --install-recommends git mono-complete mono-xbuild unzip wget unzip && rm -rf /var/lib/apt/lists/*;

# Setup Valheim dependencies
RUN wget -O bepinex.zip "https://valheim.thunderstore.io/package/download/denikson/BepInExPack_Valheim/5.4.800/" \
    && unzip bepinex.zip -d ~/BepInExRaw \
    && ../home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/steam/VHINSTALL +app_update 896660 validate +exit \
    && mv /home/steam/VHINSTALL/valheim_server_Data/ /home/steam/VHINSTALL/valheim_Data/ \
    && mv ~/BepInExRaw/BepInExPack_Valheim/unstripped_corlib/* /home/steam/VHINSTALL/valheim_Data/Managed/ \
    && mv ~/BepInExRaw/BepInExPack_Valheim/* /home/steam/VHINSTALL/ \
    && export VALHEIM_INSTALL=/home/steam/VHINSTALL/

COPY . ./

CMD xbuild JotunnLib.sln /p:Configuration=Release \
    && mkdir -p releases \
    && cp JotunnLib/obj/Release/JotunnLib.dll releases/ \
    && echo "Success! Please find the JotunnLib DLL at releases\JotunnLib.dll"
