FROM elixir:1.4

MAINTAINER meddle <n.tzvetinov@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y --no-install-recommends -q install git && rm -rf /var/lib/apt/lists/*;

ADD ./_build/prod/rel/blogit_web /blogit
WORKDIR /blogit

ENV PORT 4000
ENV MIX_ENV prod

CMD ["./bin/blogit_web", "foreground"]

EXPOSE 4000
