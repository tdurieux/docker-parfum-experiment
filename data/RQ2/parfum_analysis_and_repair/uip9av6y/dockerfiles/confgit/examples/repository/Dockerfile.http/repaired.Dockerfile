FROM httpd:alpine

EXPOSE 8022

ENV REPO_ROOT=/git \
  REPO_EXAMPLE=repo.git

COPY ./httpd.conf /usr/local/apache2/conf/extra/httpd-git.conf
COPY ./example-repo.sh /usr/local/bin/
COPY ./password /usr/local/apache2/auth/repo.password
RUN set -xe; \
  apk add --no-cache \
    git \
    git-daemon \
  && cat /usr/local/apache2/auth/repo.password \
  | htpasswd -c -i /usr/local/apache2/auth/repo.htpasswd git \
  && echo "Include conf/extra/httpd-git.conf" \
   >> /usr/local/apache2/conf/httpd.conf \
  && git config --global user.email "git@example.com" \
  && git config --global user.name "Git" \
  && git init --bare --shared "${REPO_ROOT}/${REPO_EXAMPLE}" \
  && example-repo.sh "${REPO_ROOT}/${REPO_EXAMPLE}" \
  && cp \
    "${REPO_ROOT}/${REPO_EXAMPLE}/hooks/post-update.sample" \
    "${REPO_ROOT}/${REPO_EXAMPLE}/hooks/post-update" \
  && touch "${REPO_ROOT}/${REPO_EXAMPLE}/git-daemon-export-ok" \
  && git -C "${REPO_ROOT}/${REPO_EXAMPLE}" config http.receivepack true \
  && git -C "${REPO_ROOT}/${REPO_EXAMPLE}" update-server-info \
  && chown -R daemon:daemon "${REPO_ROOT}/${REPO_EXAMPLE}"