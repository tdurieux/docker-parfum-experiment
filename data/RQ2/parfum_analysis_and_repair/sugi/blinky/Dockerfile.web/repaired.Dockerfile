FROM ruby:3
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y upgrade && apt install -y --no-install-recommends libjemalloc2 && apt clean && rm -rf /var/lib/apt/lists/*;
RUN adduser --system --home /blinky --group --uid 800 --disabled-password blinky
RUN gem install bundler
RUN apt -y --no-install-recommends install gsfonts && apt clean && rm -rf /var/lib/apt/lists/*;
COPY Gemfile* runapp /blinky/
RUN cd /blinky && bundle --without=shot
COPY bin    /blinky/bin
COPY lib    /blinky/lib
COPY views  /blinky/views
COPY public /blinky/public
EXPOSE 4567
ENV RACK_ENV deployment
ENV APP_CMD exec bundle exec ruby -Ilib bin/frontend.rb -o 0
ENV LD_PRELOAD libjemalloc.so.2
CMD /blinky/runapp
