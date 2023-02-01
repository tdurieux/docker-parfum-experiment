FROM redmine:4.2

ENV LANG=en_us

RUN apt update -qq > /dev/null \
  && apt install --no-install-recommends -qqy build-essential make vim less > /dev/null && rm -rf /var/lib/apt/lists/*;

CMD ["rails", "server", "-b", "0.0.0.0"]
