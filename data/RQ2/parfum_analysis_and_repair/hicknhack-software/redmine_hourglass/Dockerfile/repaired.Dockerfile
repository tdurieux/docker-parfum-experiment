FROM redmine:4.1.1

RUN apt-get update && apt-get install --no-install-recommends -y build-essential libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN rm /usr/src/redmine/Gemfile.lock.mysql2
RUN touch /usr/src/redmine/Gemfile.lock.mysql2
