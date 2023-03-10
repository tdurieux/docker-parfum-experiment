FROM moviemasher/moviemasher.rb:4.0.25
MAINTAINER Movie Masher <support@moviemasher.com>

# install our test gems
COPY ./config/docker/rspec/Gemfile-rspec /mnt/moviemasher.rb/Gemfile+
COPY ./Gemfile /mnt/moviemasher.rb/Gemfile

RUN cat Gemfile+ >> Gemfile ; rm Gemfile+ ; bundle install --gemfile=./Gemfile