FROM cfregly/tomcat
MAINTAINER Chris Fregly "chris@fregly.com"

# install git
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

