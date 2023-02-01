FROM ubuntu:rolling

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
CMD ["bash"]