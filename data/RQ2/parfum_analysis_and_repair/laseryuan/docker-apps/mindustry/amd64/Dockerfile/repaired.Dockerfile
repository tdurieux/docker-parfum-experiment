FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04


ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install graphic driver
# RUN apt-get update -qy && apt-get install -qy \
RUN apt-get update -qy && apt-get install -qy --no-install-recommends \
      `# libEGL support` \
      libgl1-mesa-dri \
      mesa-utils && rm -rf /var/lib/apt/lists/*;

# Install Mindustry
# https://anuke.itch.io/mindustry?download
RUN apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xdg-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y pulseaudio && rm -rf /var/lib/apt/lists/*;
ADD ./mindustry-linux-64-bit.zip /tmp/mindustry.zip
RUN cd /tmp && unzip mindustry.zip
# Finish install Mindustry

RUN useradd -ms /bin/bash mindustry

WORKDIR /home/mindustry

USER mindustry

COPY --chown=mindustry ./docker-entrypoint.sh /
COPY --chown=mindustry ./README.md /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["help"]
