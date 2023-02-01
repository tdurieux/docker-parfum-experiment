FROM    ubuntu:latest
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN apt-get update
RUN apt-get install --no-install-recommends -y python-software-properties python g++ make && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y --no-install-recommends install nodejs curl && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/magnets
Add magnets/ /magnets
RUN cd /magnets && npm install && npm cache clean --force;
# fix crappy wwwdude
RUN cp /magnets/node_modules/wwwdude/lib/wwwdude/node-versions/v0.5.x.js /magnets/node_modules/wwwdude/lib/wwwdude/node-versions/v0.10..js
# -v /media/ext/magnet_pics/:/images
ENV image_folder /images
CMD ["/magnets/run.sh"]
