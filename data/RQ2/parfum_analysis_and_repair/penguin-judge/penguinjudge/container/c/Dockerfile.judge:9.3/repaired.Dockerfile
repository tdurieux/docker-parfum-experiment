FROM ubuntu:20.04
COPY config.judge.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]