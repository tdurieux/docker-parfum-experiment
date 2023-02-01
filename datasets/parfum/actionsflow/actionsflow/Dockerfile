FROM actionsflow/act-environment:v1
ARG ACTIONSFLOW_VERSION
ARG ACT_VERSION
RUN if [ -z "$ACTIONSFLOW_VERSION" ] ; then echo "The ACTIONSFLOW_VERSION argument is missing!" ; exit 1; fi
RUN curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s $ACT_VERSION
RUN npm i -g actionsflow@${ACTIONSFLOW_VERSION} --unsafe-perm
WORKDIR /data
CMD ["actionsflow","start"]
EXPOSE 3000/tcp