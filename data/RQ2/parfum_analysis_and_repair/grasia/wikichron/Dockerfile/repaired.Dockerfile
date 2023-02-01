FROM ubuntu:bionic

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip

WORKDIR /wikichron/

# produccion only:
COPY [".", "."]

# dev only:
#COPY ["./install.sh", "."]
#COPY ["./requirements.txt", "."]

RUN bash -x install.sh

CMD ["gunicorn", "wikichron_launcher:server", "-c", "gunicorn_config.py"]

