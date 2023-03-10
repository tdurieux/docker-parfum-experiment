FROM node:12.19-alpine
WORKDIR /erxes-engages
RUN chown -R node:node /erxes-engages \
 && apk add --no-cache tzdata
COPY --chown=node:node . /erxes-engages
USER node
EXPOSE 3900
ENTRYPOINT ["node", "--max_old_space_size=8192", "dist"]