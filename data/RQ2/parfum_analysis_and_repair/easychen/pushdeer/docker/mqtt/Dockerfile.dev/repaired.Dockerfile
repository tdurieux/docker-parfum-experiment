FROM node:16-alpine3.15

RUN apk --no-cache add mosquitto mosquitto-clients
RUN npm install -g forever && npm cache clean --force;

ADD mosquitto.conf /mosquitto.conf
RUN /usr/sbin/mosquitto -c /mosquitto.conf -d

# 测试时注释掉下一行
# COPY api /api

COPY init.sh /init.sh
RUN chmod +x /init.sh
EXPOSE 1883
EXPOSE 80

ENTRYPOINT ["/bin/sh", "/init.sh"]


# ENTRYPOINT ["/usr/sbin/mosquitto", "-c", "/mosquitto.conf",""]