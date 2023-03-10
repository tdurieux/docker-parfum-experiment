FROM ubuntu:14.04
MAINTAINER Matt Konda <mkonda@jemurai.com>
RUN apt-get update && apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g retire && npm cache clean --force;
RUN ln -s /usr/bin/nodejs /usr/bin/node
CMD [ "retire" , "retire -v" ]

