# based on official Ubuntu 16.04 release
FROM cassandra:2.1

USER root

# base directory
WORKDIR /sgp

# # ------------------------------------------------------------
# # Set up JanusGraph code
# # ------------------------------------------------------------

# install necessary dependencies for powergraph
RUN apt-get update && \
	apt-get -y --no-install-recommends install default-jdk gcc openssh-server openmpi-bin python dnsutils sudo vim iputils-ping && rm -rf /var/lib/apt/lists/*;

# copy powerlyra codebase
#COPY powerlyra/ /sgp/powerlyra/
#COPY scripts/ /sgp/scripts/


# # ------------------------------------------------------------
# # initialization script
# # ------------------------------------------------------------
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

# # ------------------------------------------------------------
# # Setup
# # ------------------------------------------------------------

# ssh ports
EXPOSE 22
# janusgraph ports
EXPOSE 8182

