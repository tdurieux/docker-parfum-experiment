FROM gitlab/gitlab-ce:@VERSION@-ce.0

RUN apt-get update > /dev/null 2>&1 \
    && apt-get install -y --no-install-recommends patch > /dev/null 2>&1 && rm -rf /var/lib/apt/lists/*;

ADD app_ja.patch /tmp/
RUN cd /opt/gitlab/embedded/service/gitlab-rails \
    && patch -p1 < /tmp/app_ja.patch > /dev/null 2>&1
