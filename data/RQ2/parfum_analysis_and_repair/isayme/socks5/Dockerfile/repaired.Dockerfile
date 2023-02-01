FROM debian:latest

RUN apt-get update
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends gdb -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends procps -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*;
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

WORKDIR /app
