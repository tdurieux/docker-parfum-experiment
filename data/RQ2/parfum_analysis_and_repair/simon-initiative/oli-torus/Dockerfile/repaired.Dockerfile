FROM elixir:1.12

# use bash as shell
SHELL ["/bin/bash", "-c"]

# install node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install --no-install-recommends nodejs --yes && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# copy project files
COPY . .

# install elixir dependencies
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

# install node modules
RUN cd assets && yarn