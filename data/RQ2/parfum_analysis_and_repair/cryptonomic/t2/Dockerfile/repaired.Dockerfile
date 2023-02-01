FROM ubuntu:18.04

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install --no-install-recommends curl \
    libgtk2.0-0 \
    libnotify-bin \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    build-essential \
    python2.7 -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs mesa-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/freelife2010/T2.git

WORKDIR /T2