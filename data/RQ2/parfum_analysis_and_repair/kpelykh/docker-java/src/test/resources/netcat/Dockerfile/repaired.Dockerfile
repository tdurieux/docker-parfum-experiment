# Firefox over VNC
#
# VERSION               0.3

FROM ubuntu

#install netcat
RUN apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

EXPOSE 6900
CMD    ["nc", "-l", "6900"]