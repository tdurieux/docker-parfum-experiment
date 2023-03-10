FROM devkitpro/devkita64:latest

MAINTAINER Sergio Padrino (@sergiou87)

# Update all packages and install SDL2 and SDL2_mixer for Wii U

RUN sudo apt-get update && sudo apt-get -y --no-install-recommends install zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
CMD ["/bin/ash"]
