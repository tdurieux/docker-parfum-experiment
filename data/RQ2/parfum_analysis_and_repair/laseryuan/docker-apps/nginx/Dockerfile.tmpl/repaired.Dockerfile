FROM lasery/nginx:build as build

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

# http://nginx.org/en/download.html
RUN curl -f -L https://nginx.org/download/nginx-{{NGINX_VERSION}}.tar.gz -o /tmp/nginx.tar.gz && \
    tar xvf /tmp/nginx.tar.gz -C /tmp/ && \
    mv /tmp/nginx-"{{NGINX_VERSION}}" /tmp/nginx && rm /tmp/nginx.tar.gz

# https://github.com/arut/nginx-rtmp-module/releases
RUN curl -f -L https://github.com/arut/nginx-rtmp-module/archive/v{{RTMP_VERSION}}.tar.gz -o /tmp/rtmp.tar.gz && \
    tar xvf /tmp/rtmp.tar.gz -C /tmp/ && \
    mv /tmp/nginx-rtmp-module-{{RTMP_VERSION}} /tmp/nginx-rtmp && rm /tmp/rtmp.tar.gz

WORKDIR /tmp/nginx
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --add-module=/tmp/nginx-rtmp && \
    make && \
    make install

# Archive all shared libraries for nginx
RUN mkdir -p /usr/local/lib/nginx
RUN ldd /usr/local/nginx/sbin/nginx | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /usr/local/lib/nginx/

FROM {{ARCH.images.base}}

ENV LANG C.UTF-8
ENV LD_LIBRARY_PATH=/usr/local/lib

COPY --from=build /usr/local/nginx /usr/local/nginx
COPY --from=build /usr/local/lib/nginx /usr/local/lib/

RUN ldconfig

# Sanity Test
# RUN /usr/local/nginx/sbin/nginx -h
