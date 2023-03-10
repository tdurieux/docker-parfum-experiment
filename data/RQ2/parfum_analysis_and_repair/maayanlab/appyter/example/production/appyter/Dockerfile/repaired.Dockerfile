FROM ubuntu

ENV DEBIAN_FRONTEND "noninteractive"
ENV TZ "America/New_York"

RUN set -x \
  && echo "Preparing system..." \
  && apt-get -y update \
  && apt-get -y --no-install-recommends install git python3-pip python3-dev nginx curl \
  && curl -f https://get.docker.com | sh \
  && pip3 install --no-cache-dir --upgrade pip \
  && chmod og+rwx -R /var/lib/nginx /var/log/nginx \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && echo "Preparing user..." \
  && useradd -ms /bin/bash -d /app app \
  && adduser app docker

RUN set -x \
  && echo "Installing jupyter kernel..." \
  && pip3 install --no-cache-dir ipykernel \
  && python3 -m ipykernel install

ARG appyter_version=git+git://github.com/Maayanlab/appyter.git
RUN set -x \
  && echo "Installing appyter..." \
  && pip3 install --no-cache-dir -Iv ${appyter_version}

USER app
WORKDIR /app

CMD [ "appyter" ]
