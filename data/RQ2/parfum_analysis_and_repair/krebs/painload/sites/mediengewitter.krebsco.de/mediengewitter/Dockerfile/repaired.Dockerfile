FROM    ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y python gcc make nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node
Add mediengewitter/ /mediengewitter
RUN cd /mediengewitter && npm install && npm cache clean --force;
# -v /media/ext/magnet_pics/:/images
EXPOSE 8080
ENV PORT 8080
RUN rm /mediengewitter/public/content -r
RUN ln -s /images /mediengewitter/public/content
CMD ["/mediengewitter/run.sh"]
