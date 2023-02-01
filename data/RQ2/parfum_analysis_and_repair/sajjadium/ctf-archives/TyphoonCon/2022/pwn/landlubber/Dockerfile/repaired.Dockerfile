FROM ubuntu:22.04

RUN dpkg --add-architecture i386 && apt-get update && apt-get -y --no-install-recommends install wine wine64 xvfb wine32 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app/data

COPY landlubber.exe ..
COPY flag.txt ..
CMD ls -R ../ && (Xvfb :1 & DISPLAY=:1 wine64 ../landlubber.exe)
