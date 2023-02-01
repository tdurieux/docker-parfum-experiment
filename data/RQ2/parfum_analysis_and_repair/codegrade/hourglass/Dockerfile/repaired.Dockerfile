FROM phusion/passenger-ruby27
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD hourglass.conf /etc/nginx/sites-enabled/hourglass.conf

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs postgresql-client && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/app/hourglass
COPY Gemfile /home/app/hourglass/Gemfile
COPY Gemfile.lock /home/app/hourglass/Gemfile.lock
RUN bash -lc 'rvm install ruby-2.7.5'
RUN bash -lc 'rvm --default use ruby-2.7.5'
RUN bundle install

COPY package.json /home/app/hourglass/package.json
COPY yarn.lock /home/app/hourglass/yarn.lock
RUN npm install --global yarn && npm cache clean --force;
RUN yarn install --frozen-lockfile && yarn cache clean;

COPY ./ /home/app/hourglass

RUN mkdir -pv app/packs/relay/data/ && RAILS_ENV=development rake graphql:update_schema
RUN yarn run relay-persist
RUN SECRET_KEY_BASE="aaaa" rake assets:precompile
RUN chown -R app:app /home/app/hourglass
