# Docker container with Sysbench installed
# for running multiple types of benchmark tests

FROM ubuntu:precise
MAINTAINER Chris Collins <collins.christopher@gmail.com>

ADD . /bench
RUN apt-get install --no-install-recommends -y sysbench && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/echo", "Please specify a test script from /bench to run."]
