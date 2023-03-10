FROM centos:7

RUN printf "[nginx]\nname=nginx repo\nbaseurl=http://nginx.org/packages/centos/7/x86_64/\ngpgcheck=0\nenabled=1" > /etc/yum.repos.d/nginx.repo && \
    curl -f --silent --location https://rpm.nodesource.com/setup_8.x | bash - && \
    curl -f --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum install nginx nodejs yarn -y && \
    yum clean all && \
    sed -i 's/listen[[:space:]]*80;/listen 8080;/' /etc/nginx/conf.d/default.conf && rm -rf /var/cache/yum

RUN chmod 777 /var/log/nginx && chmod 777 /var/cache/nginx && chmod 777 /var/run && rm -rf /var/log/nginx/* && rm -rf /var/cache/nginx/*

ENV NODE_ENV=production \
    NODE_PORT=8080

WORKDIR /opt/koku-ui
ADD . /opt/koku-ui
ADD deployment/nginx.conf /etc/nginx/nginx.conf

RUN yarn --production --non-interactive --silent \
    && yarn build >/dev/null && yarn cache clean;

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
