FROM ruby:2.5.0 as base

RUN apt-get update && apt-get install --no-install-recommends -y gnuplot && rm -rf /var/lib/apt/lists/*;

RUN useradd -u 1000 gnuplot; \
    mkdir -p /home/gnuplot/gnuplot; \
    chown gnuplot.gnuplot -R /home/gnuplot

WORKDIR /home/gnuplot/gnuplot

USER gnuplot

COPY lib/ ./lib/
COPY *.gemspec ./
COPY Gemfile ./

RUN gem install bundler; bundle install
