FROM ruby:2.6.5

ENV APP_PATH=/app \
    BUNDLE_PATH=/gems

RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    nodejs && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

# Copy the main application.
ADD . $APP_PATH

EXPOSE 3000

CMD ./bin/rails server -b 0.0.0.0
