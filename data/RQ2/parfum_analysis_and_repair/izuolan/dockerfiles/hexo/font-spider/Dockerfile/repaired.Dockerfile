FROM mhart/alpine-node
USER root
RUN apk add --no-cache python g++ make
RUN npm install -g font-spider && npm cache clean --force;
WORKDIR /work
# CMD ["/run.sh"]
# font-spider /html/*
