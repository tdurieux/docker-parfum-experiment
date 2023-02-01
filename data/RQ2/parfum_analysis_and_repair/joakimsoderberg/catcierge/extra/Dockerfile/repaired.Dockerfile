FROM ubuntu:14.04

RUN apt-get update -qq -y && apt-get install --no-install-recommends -qq -y git python zsh python-pip libmagickwand-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir Wand
