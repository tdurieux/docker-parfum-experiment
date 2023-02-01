FROM steamcmd
USER root
RUN apt-get install --no-install-recommends -y software-properties-common apt-transport-https && dpkg --add-architecture i386 && wget https://dl.winehq.org/wine-builds/winehq.key && apt-key add winehq.key && apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y --install-recommends winehq-staging xvfb && rm -rf /var/lib/apt/lists/*;

