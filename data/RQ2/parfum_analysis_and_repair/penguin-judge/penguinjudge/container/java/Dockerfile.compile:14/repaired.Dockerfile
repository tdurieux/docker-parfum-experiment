FROM openjdk:14-slim
COPY config.compile.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]