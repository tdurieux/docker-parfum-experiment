FROM raspbian/stretch

MAINTAINER sheldonwl@not-my-real-email.com

RUN apt-get update
RUN apt install --no-install-recommends vim git curl wget wiringpi -y && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends python3-pip python3-blinkt -y && rm -rf /var/lib/apt/lists/*;

COPY apps /home/apps

CMD ["/usr/bin/python3", "/home/apps/pixel-controller.py"]
