ARG DOCKER_TAG

FROM ghcr.io/tomwright/dasel:latest as dasel

FROM nethermind/nethermind:${DOCKER_TAG}

# Unused, this is here to avoid build time complaints
ARG BUILD_TARGET

ARG USER=nethermind
ARG UID=10001

# See https://stackoverflow.com/a/55757473/12429735RUN
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

RUN set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends install -y ca-certificates gosu tzdata; \
	rm -rf /var/lib/apt/lists/*; \
# verify that the binary works
        gosu nobody true

# This only goes so far. keystore, logs and nethermind_db are volumes and need to be chown'd in the entrypoint
RUN chown -R ${USER}:${USER} /nethermind
RUN mkdir -p /var/lib/nethermind && chown -R ${USER}:${USER} /var/lib/nethermind

COPY --from=dasel /usr/local/bin/dasel /usr/local/bin/
COPY ./docker-entrypoint.sh /usr/local/bin/

USER ${USER}

ENTRYPOINT ["dotnet","/nethermind/Nethermind.Runner.dll"]
