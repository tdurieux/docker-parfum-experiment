FROM perl:5.36-slim

RUN apt-get -qq update && \
  apt-get -qy --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app
COPY cpanfile d2app.psgi ./
RUN cpanm --notest --installdeps .

EXPOSE 3000
CMD plackup -s Gazelle --port 3000 --env production --app d2app.psgi
