FROM node:12.13.0-slim
COPY config.json /
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]