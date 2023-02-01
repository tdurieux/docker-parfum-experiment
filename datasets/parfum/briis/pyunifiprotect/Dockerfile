FROM python:3.10-slim-bullseye as base

LABEL org.opencontainers.image.source https://github.com/briis/pyunifiprotect

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ARG TARGETPLATFORM

RUN addgroup --system --gid 1000 python \
    && adduser --system --shell /bin/bash --uid 1000 --ingroup python python

RUN --mount=type=cache,mode=0755,id=apt-$TARGETPLATFORM,target=/var/lib/apt/lists apt-get update -qq \
    && apt-get install -yqq ffmpeg


FROM base as builder

RUN --mount=type=cache,mode=0755,id=apt-$TARGETPLATFORM,target=/var/lib/apt/lists apt-get update -qq \
    && apt-get install -yqq build-essential git

COPY requirements.txt /
RUN --mount=type=cache,mode=0755,target=/root/.cache/pip pip install -U pip \
    && pip install -r /requirements.txt \
    && rm /requirements.txt


FROM base as prod

COPY --from=builder /usr/local/bin/ /usr/local/bin/
COPY --from=builder /usr/local/lib/python3.10/ /usr/local/lib/python3.10/
COPY . /tmp/pyunifiprotect
RUN pip install /tmp/pyunifiprotect \
    && mv /tmp/pyunifiprotect/.docker/entrypoint.sh /usr/local/bin/entrypoint \
    && chmod +x /usr/local/bin/entrypoint \
    && rm /tmp/pyunifiprotect -rf \
    && mkdir /data \
    && chown python:python /data

USER python
VOLUME /data
WORKDIR /data
ENTRYPOINT ["/usr/local/bin/entrypoint"]


FROM builder as builder-dev

COPY dev-requirements.txt /
RUN --mount=type=cache,mode=0755,target=/root/.cache/pip pip install -r /dev-requirements.txt \
    && rm /dev-requirements.txt


FROM base as dev

COPY --from=builder-dev /usr/local/bin/ /usr/local/bin/
COPY --from=builder-dev /usr/local/lib/python3.10/ /usr/local/lib/python3.10/
RUN --mount=type=cache,mode=0755,id=apt-$TARGETPLATFORM,target=/var/lib/apt/lists apt-get update -qq \
    && apt-get install -yqq git curl vim procps curl jq sudo \
    && echo 'python ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && echo 'export PS1="\[$(tput setaf 6)\]\w \[$(tput setaf 7)\]\$ \[$(tput sgr0)\]"' >> /home/python/.bashrc \
    && chown python:python /home/python/.bashrc

ENV PYTHONPATH /workspaces/pyunifiprotect/
ENV PATH $PATH:/workspaces/pyunifiprotect/.bin
USER python
WORKDIR /workspaces/pyunifiprotect/
