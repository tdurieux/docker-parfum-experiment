FROM alpine:3.14

RUN apk --no-cache add \
  tini \
  nodejs \
  npm \
  ffmpeg \
  && npm install -g \
  npm@latest \
  mocha@9 \
  # Clean up obsolete files: \
  && rm -rf \
  /tmp/* \
  /root/.npm && npm cache clean --force;

# Avoid permission issues with host mounts by assigning a user/group with
# uid/gid 1000 (usually the ID of the first user account on GNU/Linux):
RUN adduser -D -u 1000 mocha

USER mocha

WORKDIR /app

ENTRYPOINT ["tini", "-g", "--", "mocha"]
