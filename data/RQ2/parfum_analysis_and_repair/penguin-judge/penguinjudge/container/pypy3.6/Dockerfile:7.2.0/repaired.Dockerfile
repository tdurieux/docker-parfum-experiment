FROM pypy:3.6-7.2.0-slim
COPY config.json /
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]