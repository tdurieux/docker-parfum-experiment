FROM cfregly/git
MAINTAINER Chris Fregly "chris@fregly.com"

# install gradle
RUN apt-get -y --no-install-recommends install gradle && rm -rf /var/lib/apt/lists/*;

