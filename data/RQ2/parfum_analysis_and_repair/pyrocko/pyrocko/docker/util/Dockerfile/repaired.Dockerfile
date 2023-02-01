FROM debian:stable

RUN apt-get update -y && apt-get install --no-install-recommends -y rsync git python3-pip xvfb libgles2-mesa libfontconfig1 libxrender1 libxkbcommon-x11-0 python3-requests && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

