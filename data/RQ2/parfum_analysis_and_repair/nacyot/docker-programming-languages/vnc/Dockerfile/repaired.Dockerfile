FROM nacyot/ubuntu
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

# Install base package
RUN apt-get update
RUN apt-get install --no-install-recommends -y x11vnc xvfb firefox && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libc6-dev libpango1.0-dev libx11-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xorg-dev libgtk2.0-dev gtk2-engines-pixbuf libgtkglext1-dev rlwrap && rm -rf /var/lib/apt/lists/*;
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd abcd1234 ~/.vnc/passwd

# Set CMD
CMD x11vnc -forever -usepw -create
