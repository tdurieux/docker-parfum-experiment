FROM node:14.15.3-stretch

ENV USE_HARD_LINKS false

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends alien apt-utils g++-multilib gnupg2 psmisc && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sLS https://yarnpkg.com/install.sh | bash
