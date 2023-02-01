FROM rails:onbuild
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;