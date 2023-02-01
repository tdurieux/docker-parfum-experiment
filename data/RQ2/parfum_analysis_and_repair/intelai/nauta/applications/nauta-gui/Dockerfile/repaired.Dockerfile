# Prepare nodejs with project files
FROM centos:7.6.1810 as nauta_gui_nodejs

RUN curl -f --silent --location https://rpm.nodesource.com/setup_10.x | bash -
RUN yum update -y && yum -y install nodejs bzip2 gcc && rm -rf /var/cache/yum
ADD . /app/
WORKDIR /app

# Build gui client
FROM nauta_gui_nodejs as nauta_gui_client_build

RUN npm install && npm run build && npm cache clean --force;

# Copy client package && run backend
FROM nauta_gui_nodejs

ENV NODE_TLS_REJECT_UNAUTHORIZED 0

RUN npm install --only=prod && npm cache clean --force;

COPY --from=nauta_gui_client_build /app/dist /app/dist

EXPOSE 9000

WORKDIR /app
ENTRYPOINT ["node", "./api/server.js"]
