FROM ubuntu
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends bastet moon-buggy ninvaders nsnake pacman4console -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends nudoku && rm -rf /var/lib/apt/lists/*;
