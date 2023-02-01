FROM ubuntu:14.04
RUN dpkg --add-architecture i386
RUN apt update && apt --assume-yes -y --no-install-recommends install socat build-essential libc6:i386 libncurses5:i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/*;
RUN apt --assume-yes dist-upgrade

RUN useradd -m vuln
WORKDIR /home/vuln/
RUN chown -R root:vuln /home/vuln
RUN chmod -R 755 /home/vuln
COPY flag.txt vuln /home/vuln/
CMD su vuln -c "socat -T10 TCP-LISTEN:4444,reuseaddr,fork EXEC:/home/vuln/vuln"
EXPOSE 4444
