FROM node

RUN apt-get update
RUN npm install bower -g && npm cache clean --force;
COPY ./ /notinphilly
RUN cd /notinphilly && npm install && bower install --allow-root -f && npm cache clean --force;
COPY startNpm.sh /startNpm.sh
ENTRYPOINT ["/startNpm.sh"]
CMD ["local"]
EXPOSE 8080
