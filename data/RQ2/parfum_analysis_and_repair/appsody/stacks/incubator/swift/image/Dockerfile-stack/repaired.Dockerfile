FROM swift:5.2

LABEL Description="Appsody runtime for Swift applications"
LABEL maintainer="Ian Partridge <ianpartridge>, David Jones <djones6>"

RUN apt-get update \
 && apt-get install --no-install-recommends -y libcurl4-openssl-dev libssl-dev \
 && apt-get clean \
 && echo 'Finished installing dependencies' && rm -rf /var/lib/apt/lists/*;

ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=/project/user-app/.build
ENV APPSODY_PROJECT_DIR=/project

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/.build
ENV APPSODY_WATCH_REGEX="^.*.swift$"

ENV APPSODY_PREP="swift build"

ENV APPSODY_RUN="swift run"
ENV APPSODY_RUN_ON_CHANGE="swift run"
ENV APPSODY_RUN_KILL=true

# Allow remote debugging. The 'appsody debug' command must include the following
# flag: --docker-options "--cap-add=SYS_PTRACE --security-opt seccomp=unconfined"
# FIXME: define this in the appropriate Appsody env var once available.
ENV APPSODY_DEBUG="swift build && echo \"Ready to debug\" && lldb-server platform --listen '*:1234' --min-gdbserver-port 5000 --max-gdbserver-port 5001 --server"
ENV APPSODY_DEBUG_ON_CHANGE="swift build && echo \"Ready to debug\""
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="swift test"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config
WORKDIR /project/user-app

ENV PORT=8080

EXPOSE 8080
EXPOSE 1234
EXPOSE 5000
