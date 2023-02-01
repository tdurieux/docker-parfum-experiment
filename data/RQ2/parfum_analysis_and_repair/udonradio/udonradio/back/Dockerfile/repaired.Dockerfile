FROM python:3-stretch
ENV PYTHONUNBUFFURED 1
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Add package repo
RUN echo "deb http://deb.debian.org/debian stable main contrib non-free" > /etc/apt/sources.list

# Pillow dependencies & Liquidsoap & Gosu script
RUN apt-get update && \
    apt-get install --no-install-recommends -y --reinstall libjpeg62-turbo-dev libjpeg-turbo-progs \
        zlib1g-dev ffmpeg && \
    apt-get -y --no-install-recommends install ca-certificates curl openssh-server && rm -rf /var/lib/apt/lists/*;

# Install gosu script
RUN gpg \
      --batch \
      --keyserver ha.pool.sks-keyservers.net \
      --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
    curl -f \
      -o /usr/local/bin/gosu \
      -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(\
        dpkg --print-architecture)" && \
    curl -f \
      -o /usr/local/bin/gosu.asc \
      -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(\
        dpkg --print-architecture).asc" && \
    gpg --batch \
      --verify /usr/local/bin/gosu.asc && \
    rm /usr/local/bin/gosu.asc && chmod +x /usr/local/bin/gosu

ADD requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir uwsgi

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["uwsgi", "--chdir=/usr/src/app", "--module=udon_back.wsgi:application", "--socket=0.0.0.0:8000"]
