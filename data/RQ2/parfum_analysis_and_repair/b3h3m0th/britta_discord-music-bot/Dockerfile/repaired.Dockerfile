FROM ubuntu:latest
WORKDIR /app

RUN apt update -y && apt upgrade -y && apt install --no-install-recommends tzdata -y && rm -rf /var/lib/apt/lists/*;

RUN echo "Asia/Kolkata" | tee /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt install --no-install-recommends wget git curl -y && rm -rf /var/lib/apt/lists/*;

RUN export PORT=5000

RUN apt install --no-install-recommends make python gcc g++ python3-pip build-essential bash git ffmpeg libopus-dev libffi-dev libsodium-dev python3 python git -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

COPY . /app

RUN node -v
RUN npm -v

RUN npm install && npm cache clean --force;

RUN apt purge nodejs -y

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN node -v
RUN npm -v

CMD ["bash","run.sh"]