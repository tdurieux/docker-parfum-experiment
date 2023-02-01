FROM debian:buster
RUN apt update \
    && apt install --no-install-recommends -y python devscripts build-essential gawk help2man lsb-release \
    && groupadd -g 1004 builduser \
    && useradd -m -u 1003 -g builduser builduser && rm -rf /var/lib/apt/lists/*;

USER builduser
RUN mkdir /home/builduser/configsnap
WORKDIR /home/builduser/configsnap
CMD ["make","deb"]
