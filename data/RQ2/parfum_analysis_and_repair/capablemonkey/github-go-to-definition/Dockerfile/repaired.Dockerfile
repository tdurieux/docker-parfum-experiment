FROM ruby:2.1-onbuild
RUN apt-get -y update && apt-get -y --no-install-recommends install ctags unzip && rm -rf /var/lib/apt/lists/*;
EXPOSE 80
CMD bundle exec ruby app.rb -p 80 -o 0.0.0.0