FROM webratio/nodejs-http-server
VOLUME /tmp
ADD dist /opt/www
ADD run.sh /opt/run.sh
ARG CI_PROJECT_NAME
ARG CI_COMMIT_SHA
ENV CI_PROJECT_NAME=$CI_PROJECT_NAME
ENV CI_COMMIT_SHA=$CI_COMMIT_SHA
EXPOSE 8080
ENTRYPOINT ["sh","/opt/run.sh"]