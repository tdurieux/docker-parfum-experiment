# ================================================================= #
# ------------ First stage in our multistage Dockerfile ----------- #
# ================================================================= #
FROM python:3.6-slim as Base

RUN apt-get update \
  && apt-get install --no-install-recommends -y curl git && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/ci-workshop-app

COPY requirements.txt /home/ci-workshop-app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /home/ci-workshop-app

# ================================================================= #
# ------------ Second stage in our multistage Dockerfile ---------- #
# ================================================================= #

FROM Base as Build

ARG CI
ENV CI=$CI

RUN /home/ci-workshop-app/bin/train_model.sh

# CMD ["/home/ci-workshop-app/bin/start_server.sh"]

# ================================================================= #
# ------------ Third stage in our multistage Dockerfile ----------- #
# ================================================================= #
FROM Build as Dev

RUN apt-get install --no-install-recommends -y gnupg \
  && curl -f https://cli-assets.heroku.com/install-ubuntu.sh | sh && rm -rf /var/lib/apt/lists/*;

COPY requirements-dev.txt /home/ci-workshop-app/requirements-dev.txt
RUN pip install --no-cache-dir -r /home/ci-workshop-app/requirements-dev.txt

RUN git config --global credential.helper 'cache --timeout=36000'

EXPOSE 8080

ARG user
RUN useradd ${user:-root} -g root || true
USER ${user:-root}

# CMD ["/home/ci-workshop-app/bin/start_server.sh"]
