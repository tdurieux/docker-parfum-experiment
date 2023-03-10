ARG version=stable
FROM debian:${version}
ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
 && apt -y upgrade
RUN apt -y --no-install-recommends install gjs sudo xvfb && rm -rf /var/lib/apt/lists/*;
RUN useradd -ms /bin/bash jiggle \
 && mkdir -p /home/jiggle/.local/share/gnome-shell/extensions/jiggle@jeffchannell.com \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists*
WORKDIR /home/jiggle/.local/share/gnome-shell/extensions/jiggle@jeffchannell.com
COPY . .
ENTRYPOINT [ "./entrypoint.sh" ]
