FROM ruby:2.6.6-stretch
ENV LC_ALL=C.UTF-8

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;

COPY Gemfile* /app/
COPY package*.json /app/

WORKDIR /app

RUN bundle install
RUN npm install && npm cache clean --force;

CMD npm start
