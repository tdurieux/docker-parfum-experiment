FROM devkitpro/devkitarm:latest

MAINTAINER Sergio Padrino (@sergiou87)

# Update all packages and install SDL2 and SDL2_mixer for Wii U

RUN sudo apt-get update \
	&& sudo apt-get -y --no-install-recommends install zip \
	&& sudo dkp-pacman -Sy \
	&& sudo dkp-pacman -S dkp-libs/3ds-sdl --noconfirm && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
CMD ["/bin/ash"]
