FROM registry.hawkengine.net:5000/hawkbase:latest
MAINTAINER Radoslav Minchev <rminchev@rnd-solutions.net>

#setup file structure
RUN mkdir -p /usr/src/app/source /usr/src/app/build && rm -rf /usr/src/app/source
WORKDIR /usr/src/app/source
COPY . /usr/src/app/source

#navigate to the source
WORKDIR /usr/src/app/source/src


#compile HServer
RUN nuget restore -NonInteractive
RUN xbuild /property:Configuration=Release /property:OutDir=/usr/src/app/build/
WORKDIR /usr/src/app/build
RUN mkdir www

#change working dir
WORKDIR /usr/src/app/source/src/ui

#install nodejs packages
RUN npm install && npm cache clean --force;

#install bower packages
RUN bower install --allow-root

#build the app
RUN npm install --global gulp-cli \
    && gulp build && npm cache clean --force;

#create revision file
RUN git rev-parse HEAD > dist/rev.txt

#copy the minified and combined app assets to www
RUN cp -r dist/* /usr/src/app/build/www/ 

WORKDIR /usr/src/app/build

#run when the container is started
CMD ["mono", "./HawkEngine.Server.exe"]


