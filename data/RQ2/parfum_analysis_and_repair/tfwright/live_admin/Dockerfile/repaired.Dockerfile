FROM bitwalker/alpine-elixir-phoenix:latest

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD assets assets/
RUN npm --prefix assets install && npm cache clean --force;
RUN npm --prefix assets run build
