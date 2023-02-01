# please follow docker best practices
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/

FROM buildbot/buildbot-master:master
COPY example /usr/src/buildbot_travis/example

RUN \
    pip install --no-cache-dir buildbot_travis && \
    rm -r /root/.cache

EXPOSE 8010
EXPOSE 9989

CMD ["/usr/src/buildbot_travis/example/start_buildbot.sh"]
