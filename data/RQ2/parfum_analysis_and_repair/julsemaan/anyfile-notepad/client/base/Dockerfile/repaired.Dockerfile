FROM node:16-buster

RUN apt-get update -yqq && apt-get install --no-install-recommends -yqq perl gcc curl make inotify-tools && rm -rf /var/lib/apt/lists/*;
RUN cpan Template Getopt::Long JSON File::Slurp Tie::IxHash


