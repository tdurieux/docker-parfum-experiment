FROM ruby:2.7
MAINTAINER Movie Masher <support@moviemasher.com>

# # # # # # # # # # # # # # # #
#  BUNDLED GEMS
COPY ./config/docker/rubocop/Gemfile-rubocop /mnt/data/Gemfile
RUN cd /mnt/data/; bundle install;

WORKDIR /mnt/data