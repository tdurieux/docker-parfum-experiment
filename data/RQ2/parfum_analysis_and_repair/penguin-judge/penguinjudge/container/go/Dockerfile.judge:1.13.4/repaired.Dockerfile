FROM golang:1.13.4-alpine
COPY config.judge.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]