FROM node:16
# RUN apt-get update && \
#     apt-get -y install git
WORKDIR /workspace
RUN git clone \
  --single-branch --branch master \
  --depth=1 \
  https://github.com/effector/effector.git /workspace && \
  rm -rf /workspace/.git
RUN yarn && yarn cache clean;
CMD ["node", "tools/builder.js"]
