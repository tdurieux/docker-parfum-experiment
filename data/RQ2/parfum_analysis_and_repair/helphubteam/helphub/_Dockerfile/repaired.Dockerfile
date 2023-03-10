FROM lnikell/rails-pack-helphub:latest

WORKDIR /app

ENV BUNDLER_VERSION=2.1.4

RUN gem install bundler -v 2.1.4  
RUN apt-get update && apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

COPY Gemfile Gemfile.lock package.json yarn.lock ./

RUN bundle install
RUN yarn --check-files

COPY . .

RUN rm -rf /app/public/reports
RUN ln -s /reports /app/public/reports
