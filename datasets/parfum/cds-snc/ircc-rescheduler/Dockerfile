FROM node:lts-alpine
MAINTAINER Dave Samojlenko <dave.samojlenko@cds-snc.ca>

ARG PAPER_FILE_NUMBER_PATTERN
ARG RAZZLE_FLAGS
ARG RAZZLE_GA_ID
ENV RAZZLE_PAPER_FILE_NUMBER_PATTERN ${PAPER_FILE_NUMBER_PATTERN}
ENV RAZZLE_FLAGS ${RAZZLE_FLAGS}
ENV RAZZLE_GA_ID ${RAZZLE_GA_ID}

ADD ./ /web
ADD ./entrypoint.sh /entrypoint.sh

WORKDIR /web

EXPOSE 3004

RUN yarn install --production
RUN yarn build

USER node

ENTRYPOINT ["/entrypoint.sh"]
