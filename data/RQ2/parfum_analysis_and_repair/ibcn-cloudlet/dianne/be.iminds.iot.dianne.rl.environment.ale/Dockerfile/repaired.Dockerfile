FROM dianne

# install ALE dependencies
USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
	libsdl1.2-dev \
	libsdl-gfx1.2-dev \
	libsdl-image1.2-dev && rm -rf /var/lib/apt/lists/*;

USER dianne


# build and export ALE runtime
RUN ./gradlew assemble export.runtime.agent.ale

# set default target
ENV TARGET runtime.agent.ale

# run
ENTRYPOINT ["/home/dianne/be.iminds.iot.dianne.rl.environment.ale/entrypoint.sh"]
