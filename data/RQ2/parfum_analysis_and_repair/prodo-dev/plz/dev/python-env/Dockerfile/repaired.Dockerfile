FROM python:3
RUN apt-get update -qq && apt-get install --no-install-recommends -qqy make zsh && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir virtualenv
