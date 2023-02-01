FROM ubuntu:14.04
RUN dpkg --add-architecture i386
RUN apt update && apt --assume-yes -y --no-install-recommends install socat build-essential libc6:i386 libncurses5:i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/*;
RUN apt --assume-yes dist-upgrade

RUN useradd -m pwn0
WORKDIR /home/pwn0
RUN chown -R root:pwn0 /home/pwn0
RUN chmod -R 755 /home/pwn0
COPY flag.txt pwn0 /home/pwn0/
CMD su pwn0 -c "socat -T10 TCP-LISTEN:4444,reuseaddr,fork EXEC:/home/pwn0/pwn0"
EXPOSE 4444
