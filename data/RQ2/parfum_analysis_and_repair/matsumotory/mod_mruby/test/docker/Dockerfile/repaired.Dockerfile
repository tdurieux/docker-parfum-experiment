FROM stackbrew/ubuntu:14.04
#
MAINTAINER matsumotory
#
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install sudo openssh-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apache2 apache2-dev apache2-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ruby2.0 ruby2.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhiredis-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libmarkdown2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcap-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcgroup-dev && rm -rf /var/lib/apt/lists/*;
#
RUN cd /usr/local/src/ && git clone https://github.com/matsumoto-r/mod_mruby.git
RUN cd /usr/local/src/mod_mruby && sh test.sh
