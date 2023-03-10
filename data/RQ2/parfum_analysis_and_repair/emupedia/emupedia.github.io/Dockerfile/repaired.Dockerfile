FROM gitpod/workspace-full:latest

USER root

RUN apt-get update \
&& apt-get install --no-install-recommends -y mc \
&& apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*