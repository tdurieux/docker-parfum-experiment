FROM devkitpro/devkitppc:latest

MAINTAINER Sergio Padrino (@sergiou87)

# Update all packages and install SDL and SDL_mixer for Wii

RUN ln -sf /proc/mounts /etc/mtab \
    && sudo dkp-pacman -Syu --noconfirm \
    && sudo dkp-pacman -S wii-sdl wii-sdl_mixer --noconfirm \
    && sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
CMD ["/bin/ash"]
