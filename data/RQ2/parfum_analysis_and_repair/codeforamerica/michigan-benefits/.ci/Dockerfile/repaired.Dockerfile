FROM circleci/ruby:2.5.3-node-browsers
RUN sudo apt-get update; sudo apt-get install -y --no-install-recommends pdftk libmagic-dev && rm -rf /var/lib/apt/lists/*;
