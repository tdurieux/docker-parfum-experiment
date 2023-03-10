FROM openjdk:8

# Install sendmail utils
RUN apt-get update && apt-get install --no-install-recommends -y mailutils && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y sendmail && rm -rf /var/lib/apt/lists/*;

# Add the build artifact under /opt, can be overridden by docker build
ARG ARTIFACT_PATH=target/doctork-0.2.4.10-bin.tar.gz
ADD $ARTIFACT_PATH /opt/doctork/
# default cmd
CMD /opt/doctork/scripts/run_in_container.sh
