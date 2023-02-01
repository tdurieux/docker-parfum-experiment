FROM ubuntu:14.04
RUN dpkg --add-architecture i386
RUN apt update && apt --assume-yes -y --no-install-recommends install socat build-essential libc6:i386 libncurses5:i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/*;
RUN apt --assume-yes dist-upgrade

RUN useradd -m pwn3
WORKDIR /home/pwn3
RUN chown -R root:pwn3 /home/pwn3
RUN chmod -R 755 /home/pwn3
COPY flag.txt pwn3 /home/pwn3/
CMD su pwn3 -c "socat -T10 TCP-LISTEN:4444,reuseaddr,fork EXEC:/home/pwn3/pwn3"
EXPOSE 4444
