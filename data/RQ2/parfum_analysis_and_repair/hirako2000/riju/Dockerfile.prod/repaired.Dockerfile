FROM ubuntu:rolling

# This is just here so we can reuse the Docker cache between dev and
# prod, it's not actually read by anything.
ARG UID

COPY scripts/my_init /usr/bin/my_init

COPY scripts/docker-install-phase0.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase0.bash"

COPY scripts/docker-install-phase1.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase1.bash"

COPY scripts/docker-install-phase2.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase2.bash"

COPY scripts/docker-install-phase3a.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase3a.bash"

COPY scripts/docker-install-phase3b.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase3b.bash"

COPY scripts/docker-install-phase3c.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase3c.bash"

COPY scripts/docker-install-phase3d.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase3d.bash"

COPY scripts/docker-install-phase4.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase4.bash"

COPY scripts/docker-install-phase5.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase5.bash"

COPY scripts/docker-install-phase6.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase6.bash"

COPY scripts/docker-install-phase7.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase7.bash"

COPY scripts/docker-install-phase8.bash /tmp/
RUN bash -c "time /tmp/docker-install-phase8.bash '$UID'"

USER docker
WORKDIR /home/docker
RUN chmod go-rwx /home/docker
EXPOSE 6119
EXPOSE 6120

ENTRYPOINT ["/usr/bin/my_init", "/usr/local/bin/pid1.bash"]
COPY scripts/pid1.bash /usr/local/bin/
CMD ["yarn", "run", "server"]

RUN mkdir /tmp/riju /tmp/riju/scripts
COPY --chown=docker:docker package.json yarn.lock /tmp/riju/
RUN bash -c "cd /tmp/riju && time yarn install"
COPY --chown=docker:docker webpack.config.js tsconfig.json tsconfig-webpack.json /tmp/riju/
COPY --chown=docker:docker frontend /tmp/riju/frontend
RUN bash -c "cd /tmp/riju && time yarn run frontend"
COPY --chown=docker:docker backend /tmp/riju/backend
RUN bash -c "cd /tmp/riju && time yarn run backend"
COPY --chown=docker:docker scripts/compile-system.bash /tmp/riju/scripts
COPY --chown=docker:docker system /tmp/riju/system
RUN bash -c "cd /tmp/riju && time RIJU_PRIVILEGED=1 yarn run system"
COPY --chown=docker:docker . /home/docker/src
RUN sudo cp -a /tmp/riju/* /home/docker/src/ && rm -rf /tmp/riju

WORKDIR /home/docker/src
RUN sudo deluser docker sudo
RUN RIJU_PRIVILEGED=1 CONCURRENCY=1 TIMEOUT_FACTOR=5 LANG=C.UTF-8 LC_ALL=C.UTF-8 yarn test && yarn cache clean;
