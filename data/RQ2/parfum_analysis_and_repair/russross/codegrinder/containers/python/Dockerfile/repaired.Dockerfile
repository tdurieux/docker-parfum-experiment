FROM arm64v8/debian:bullseye
MAINTAINER russ@russross.com

RUN apt update && apt upgrade -y

RUN apt install -y --no-install-recommends \
    make \
    python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends \
    build-essential \
    gdb && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends \
    mypy \
    python3-pip \
    python3-setuptools \
    python3-six \
    diffutils && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libfreetype6-dev \
    libjpeg-dev \
    python3-dev \
    libportmidi-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir unittest-xml-reporting cisc108 pygame

RUN mkdir /home/student && chmod 777 /home/student
USER 2000
WORKDIR /home/student
