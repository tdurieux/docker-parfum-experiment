FROM node:12

ADD start_log_agent.sh .

RUN npm install -g frontail && npm cache clean --force;

EXPOSE 9001

CMD ["sh", "start_log_agent.sh"]
