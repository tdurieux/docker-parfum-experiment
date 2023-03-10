FROM ubuntu
LABEL maintainer="snovvcrash@protonmail.ch"
ENV LANG="C.UTF-8"
RUN apt update && apt install --no-install-recommends python3 python3-venv -y && rm -rf /var/lib/apt/lists/*;
COPY . /src
WORKDIR /src
RUN python3 gen-demo-syslog.py && bash installers/install.sh && rm -rf /var/opt/usbrip
ENTRYPOINT ["usbrip"]
