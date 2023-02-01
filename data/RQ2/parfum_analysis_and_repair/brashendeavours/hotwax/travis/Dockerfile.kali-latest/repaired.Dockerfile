FROM kalilinux/kali:latest

RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get full-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python3 \
    python3-pip \
    init && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install -U pip ansible

ENTRYPOINT ["/sbin/init"]
