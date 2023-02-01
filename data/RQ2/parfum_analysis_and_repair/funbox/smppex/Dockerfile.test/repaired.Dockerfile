FROM elixir

ENV MIX_ENV=test

RUN apt-get update
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen

RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /app
WORKDIR /app

ADD mix.* ./

RUN mix deps.get
RUN mix deps.compile

ADD . ./

CMD ["mix", "test"]

