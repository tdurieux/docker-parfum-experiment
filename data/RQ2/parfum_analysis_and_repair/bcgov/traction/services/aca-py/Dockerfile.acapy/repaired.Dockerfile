FROM bcgovimages/aries-cloudagent:py36-1.16-1_0.7.4-rc0

USER root

ADD https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 ./jq
RUN chmod +x ./jq
COPY ngrok-wait.sh ngrok-wait.sh
RUN chmod +x ./ngrok-wait.sh

USER $user