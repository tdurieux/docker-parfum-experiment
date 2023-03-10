FROM rust:1.45.0-slim
COPY work-v1 /work
WORKDIR /work
RUN cargo build --release
COPY config.compile.v1.json /config.json
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]