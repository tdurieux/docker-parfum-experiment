FROM kalilinux/kali-rolling

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends whatweb -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT [ "whatweb" ]