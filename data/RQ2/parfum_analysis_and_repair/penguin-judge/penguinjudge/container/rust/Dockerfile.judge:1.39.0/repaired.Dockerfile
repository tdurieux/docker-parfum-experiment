FROM rust:1.39.0-slim
COPY config.judge.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]