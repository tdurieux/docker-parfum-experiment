FROM    ubuntu
MAINTAINER      fintan@weave.works

RUN     apt-get -y update
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;

# add our app
RUN 	mkdir -p /opt/app
COPY	app/. /opt/app
RUN cd /opt/app && npm install && npm cache clean --force;

# and run our offer-service

CMD	["nodejs", "/opt/app/services/user-details.js" ]
