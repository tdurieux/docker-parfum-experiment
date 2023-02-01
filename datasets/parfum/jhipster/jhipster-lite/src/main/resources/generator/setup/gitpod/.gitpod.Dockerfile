FROM gitpod/workspace-full:latest

# Update java version
USER gitpod
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
        && sdk update \
        && sdk install java 17.0.1-tem"
