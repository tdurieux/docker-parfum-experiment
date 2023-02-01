FROM ruby:2.7.3
EXPOSE 4567

RUN apt-get update && apt-get install --no-install-recommends -y git nodejs && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/OpenDroneMap/WebODM /webodm --depth 1

WORKDIR /webodm/slate
RUN bundle install

ENTRYPOINT ["bundle", "exec", "middleman", "server"]
