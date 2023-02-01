FROM devkitpro/devkitppc:latest

MAINTAINER Sergio Padrino (@sergiou87)

# Update all packages and install SDL2 and SDL2_mixer for Wii U

RUN ln -sf /proc/mounts /etc/mtab \
    && sudo dkp-pacman -Syu --noconfirm \
    && sudo dkp-pacman -S wiiu-sdl2 wiiu-sdl2_mixer --noconfirm \
    && sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
CMD ["/bin/ash"]
