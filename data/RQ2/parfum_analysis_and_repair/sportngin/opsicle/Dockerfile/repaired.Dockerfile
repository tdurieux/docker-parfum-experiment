FROM ruby:slim

RUN apt-get update -q && \
    apt-get install --no-install-recommends -qy \
    libncurses5-dev libncursesw5-dev gcc libffi-dev make ssh && rm -rf /var/lib/apt/lists/*;

RUN gem install opsicle

ENTRYPOINT ["opsicle"]
