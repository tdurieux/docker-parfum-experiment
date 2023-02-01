FROM elixir:1.9

RUN apt-get update
RUN apt-get install --no-install-recommends --yes postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends make gcc libc-dev && rm -rf /var/lib/apt/lists/*;

# install hex package manager
RUN mix local.hex --force
RUN mix local.rebar --force

# install the latest version of Phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install NodeJS and NPM
RUN curl -f -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y inotify-tools && rm -rf /var/lib/apt/lists/*;

# copy our code into a new directory named 'app' it and set it as our working directory
COPY . /app
WORKDIR /app

# Convert entrypoint.sh to an executable file
# (Note: this file will run every time the container starts up)
COPY ./docker/app/entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]