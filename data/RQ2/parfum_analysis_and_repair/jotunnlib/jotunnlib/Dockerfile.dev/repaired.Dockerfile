# Pull latest Ubuntu latest
FROM cm2network/steamcmd:latest

USER root

# Set working directory
WORKDIR /build

# Setup SteamCMD
RUN apt update \
    && apt install --no-install-recommends --yes --install-recommends git mono-complete mono-xbuild unzip wget unzip && rm -rf /var/lib/apt/lists/*;

COPY . ./

CMD xbuild JotunnLib.sln /p:Configuration=Debug \
    && cp JotunnLib/obj/Debug/JotunnLib.dll /VHINSTALL/BepInEx/plugins/\
    && echo "Success! JotunnLib has been install to Valheim install directory for testing"
