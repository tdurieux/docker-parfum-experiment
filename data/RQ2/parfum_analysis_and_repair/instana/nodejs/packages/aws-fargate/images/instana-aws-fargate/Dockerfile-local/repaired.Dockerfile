FROM node:12.22.7-buster AS instana-aws-fargate-build-nodejs

ARG legacy_package_version_range="<2.0.0"

# ---- @instana/aws-fargate@1.x for Node.js < 10.x ----
WORKDIR /instana/legacy-1x
COPY package.json.npm ./
RUN sed -e s/SELF_VERSION/1.0.0/g \
        -e s/INSTANA_AWS_FARGATE_VERSION/$legacy_package_version_range/g \
        package.json.npm > package.json
COPY .npmrc ./
RUN npm install --only=production && npm cache clean --force;
RUN rm -f instana-*.tgz && \
 rm -f package.json && \
 rm -f package.json.npm && \
 rm -f .npmrc

# ---- @instana/aws-fargate@latest for Node.js >= 10.x ----
WORKDIR /instana
COPY package.json ./
COPY instana-*.tgz ./
COPY .npmrc ./
COPY setup.sh ./
RUN npm install --only=production && npm cache clean --force;
RUN rm -f instana-*.tgz
RUN rm -f package.json
RUN rm -f .npmrc

# ---- Start over from scratch and copy npm modules
FROM scratch
COPY --from=instana-aws-fargate-build-nodejs /instana /instana

