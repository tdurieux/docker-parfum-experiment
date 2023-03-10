ARG TAG=faraday-agent-dispatcher
FROM registry.gitlab.com/faradaysec/cloud/faraday_agent_dispatcher:$TAG


WORKDIR /usr/local/src/faraday_agent_dispatcher
COPY ./faraday_agent_dispatcher/ /usr/local/src/faraday_agent_dispatcher/faraday_agent_dispatcher
COPY ./setup.py /usr/local/src/faraday_agent_dispatcher/setup.py
COPY ./README.md /usr/local/src/faraday_agent_dispatcher/README.md
COPY ./RELEASE.md /usr/local/src/faraday_agent_dispatcher/RELEASE.md
COPY ./MANIFEST.in /usr/local/src/faraday_agent_dispatcher/MANIFEST.in

RUN pip3 install --no-cache-dir .

ENTRYPOINT ["faraday-dispatcher", "run"]
