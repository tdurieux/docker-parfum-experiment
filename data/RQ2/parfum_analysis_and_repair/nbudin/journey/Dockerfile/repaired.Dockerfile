from ruby:2.6.2

run apt-get install --no-install-recommends -y libmysqlclient-dev libmagickwand-dev && rm -rf /var/lib/apt/lists/*;

add . /app
run cp /app/config/database.yml.docker /app/config/database.yml
run cd /app ; bundle install --without development test

env RAILS_ENV production
expose 3000
cmd ["ruby", "/app/script/rails", "server", "-p", "3000"]
