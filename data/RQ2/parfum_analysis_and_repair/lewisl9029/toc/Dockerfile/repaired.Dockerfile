FROM node:4.2.1-slim

MAINTAINER Lewis Liu

RUN apt-get update && apt-get install --no-install-recommends -y \
  git && \
  apt-get clean && \
  rm -rf /tmp/* /var/tmp/* && rm -rf /var/lib/apt/lists/*;

# installing npm dependencies
COPY ./scripts/toc-install-deps.sh /root/toc-install-deps.sh
RUN /bin/bash /root/toc-install-deps.sh

# expose ionic serve, livereload
EXPOSE 8100 8101

# adding volume mounts for project files
WORKDIR /toc
VOLUME /toc
VOLUME /root/.ionic
VOLUME /root/.jspm

CMD ["bash"]
