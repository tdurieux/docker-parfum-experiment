FROM alpine
ARG version

# No time for careful testing now, bash is needed for its parameter expansion capabilities.
# Perhaps ash supports same parameter expansion capabilites.
# Curl is needed for interaction with Cloudant REST API.
# Nodejs is needed from Cloudant backup/restore utilities.
# Install bash, curl, nodejs, npm, jq (npm is a nodejs pre-req)
#
RUN apk add --no-cache --update bash curl nodejs jq
RUN npm install -g @cloudant/couchbackup && npm cache clean --force;
RUN npm install -g coucher && npm cache clean --force;

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

COPY $version/*.sh /

CMD /cloudant-backup.sh
