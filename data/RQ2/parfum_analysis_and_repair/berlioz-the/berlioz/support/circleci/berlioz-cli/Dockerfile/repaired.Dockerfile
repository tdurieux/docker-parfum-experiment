FROM circleci/node:9-jessie

RUN sudo npm install berlioz -g && npm cache clean --force;