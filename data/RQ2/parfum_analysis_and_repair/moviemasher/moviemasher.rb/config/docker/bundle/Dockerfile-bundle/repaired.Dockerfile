FROM ruby:2.7
MAINTAINER Movie Masher <support@moviemasher.com>

# # # # # # # # # # # # # # # #
#  DEFAULT COMMAND
CMD bundle install

# # # # # # # # # # # # # # # #
#  WORKING DIRECTORY
WORKDIR /data