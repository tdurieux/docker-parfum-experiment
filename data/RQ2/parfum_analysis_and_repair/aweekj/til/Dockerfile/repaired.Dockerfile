FROM ruby:latest
RUN apt-get -y update && apt-get -y --no-install-recommends install libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN gem install gollum
RUN gem install github-markdown org-ruby
VOLUME /wiki
WORKDIR /wiki
CMD ["gollum", "--port", "80"]
EXPOSE 80

