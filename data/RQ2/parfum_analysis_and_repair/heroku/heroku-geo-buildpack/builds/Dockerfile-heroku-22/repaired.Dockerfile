FROM heroku/heroku:22-build

RUN apt-get -q update && apt-get -q -y --no-install-recommends install awscli libsqlite3-dev sqlite3 && rm -rf /var/lib/apt/lists/*;

ADD . /heroku-geo-buildpack

WORKDIR "/heroku-geo-buildpack"