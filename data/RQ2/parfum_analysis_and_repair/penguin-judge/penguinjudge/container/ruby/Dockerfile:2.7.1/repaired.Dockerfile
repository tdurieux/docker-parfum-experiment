FROM ruby:2.7.1-slim as build
RUN apt update \
    && apt install --no-install-recommends -y build-essential \
    && gem install numo-narray -v  0.9.1.8 \
    && rm -rf /usr/local/bundle/cache/* && rm -rf /var/lib/apt/lists/*;

FROM ruby:2.7.1-slim
ENV RUBY_THREAD_VM_STACK_SIZE=268435456
COPY --from=build /usr/local/bundle /usr/local/bundle/
COPY config.json /
COPY penguin_judge_agent /bin
CMD ["/bin/penguin_judge_agent"]
