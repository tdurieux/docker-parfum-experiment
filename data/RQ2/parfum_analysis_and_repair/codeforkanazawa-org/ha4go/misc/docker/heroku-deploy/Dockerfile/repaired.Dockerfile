FROM debian:jessie

MAINTAINER PharaohKJ <kato@phalanxware.com>

RUN export DEBIAN_FRONTEND=noninteractive LANG
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y git ruby make ssh wget sudo apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
RUN mkdir ~/.ssh && chmod og-rw ~/.ssh && ssh-keyscan github.com > ~/.ssh/known_hosts
ADD ./heroku_login heroku_login
RUN heroku auth:login < heroku_login
RUN git clone -b develop https://github.com/jshimazu/ha4go.git
RUN cd ha4go && heroku git:remote -a ha4go-develop
CMD "/bin/bash"
