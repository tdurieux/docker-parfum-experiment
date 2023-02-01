FROM ruby:2.6.2

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;

COPY Gemfile* ./
RUN bundler install
COPY . ./
EXPOSE 8080
CMD ["sh", "-c", "rails db:migrate && rails server -p=8080 -b=0.0.0.0"]