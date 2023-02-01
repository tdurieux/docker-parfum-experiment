# Sets up a container for the web based lab login
#
# VERSION               0.0.1

# At some point, more of this will be pushed into its own docker image

FROM      ubuntu
MAINTAINER Preston Holmes "preston@ptone.com"

RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y -q python-dev python-dev-all && rm -rf /var/lib/apt/lists/*;

# sshd
RUN apt-get install --no-install-recommends -y -q openssh-server && rm -rf /var/lib/apt/lists/*;
EXPOSE 22

RUN apt-get install --no-install-recommends -y -q sudo gcc make nano sqlite3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y -q python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U pip

# git
RUN apt-get install --no-install-recommends -y -q libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q git && rm -rf /var/lib/apt/lists/*;
# TODO add git configs

RUN
RUN
RUN
RUN
RUN

