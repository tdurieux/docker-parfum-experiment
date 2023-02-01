FROM node:16-alpine
COPY . /home
WORKDIR /home
RUN apk add --no-cache bash && \
    yarn install && \
    yarn build && \
    chmod +x /home/hack/wait_for_it.sh && yarn cache clean;
EXPOSE 3001
EXPOSE 8443
