FROM ubuntu:latest AS build

RUN apt update
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY ./.git ./.git
COPY ./mozilla-ca ./mozilla-ca
COPY ./setup.py ./setup.py
COPY ./build_scripts ./build_scripts
COPY ./chaingreen ./chaingreen
COPY ./install.sh ./install.sh
COPY ./install-gui.sh ./install-gui.sh
COPY ./install-timelord.sh ./install-timelord.sh

RUN sh install.sh
# tzdata is installed in install-gui.sh script, but it's interactive
# so we install it before the script is started in non-interactive mode
RUN DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN . ./activate && sh install-gui.sh && sh install-timelord.sh && chaingreen keys generate && chaingreen init && chaingreen start -r all