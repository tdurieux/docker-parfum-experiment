FROM appsody/swift:0.2

# Fix Python package layout before installing dependencies. This is a bug in the Swift
# base image and this workaround should be removed once the base image is corrected.
# See: https://bugs.swift.org/browse/SR-10344
RUN apt-get update \
 && if [ -d "/usr/lib/python2.7/site-packages" ]; then mv /usr/lib/python2.7/site-packages/* /usr/lib/python2.7/dist-packages && rmdir /usr/lib/python2.7/site-packages && ln -s dist-packages /usr/lib/python2.7/site-packages ; fi \
 && apt-get install --no-install-recommends -y zlib1g-dev libcurl4-openssl-dev libssl-dev \
 && apt-get clean \
 && echo 'Finished installing dependencies' && rm -rf /var/lib/apt/lists/*;

ENV APPSODY_MOUNTS=/:/project/user-app
ENV APPSODY_DEPS=/project/user-app/.build

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR="/project/user-app/.build;/project/user-app/.appsody"
ENV APPSODY_WATCH_REGEX="^.*.swift$"

# Re-copy project dependencies from base image, if they have been modified
ENV APPSODY_PREP="if [ ! -d /project/user-app/.appsody ] || [ -n \"$(diff -rq /project/deps /project/user-app/.appsody)\" ]; then rm -rf /project/user-app/.appsody && cp -R -p /project/deps /project/user-app/.appsody; fi"

ENV APPSODY_RUN="swift run"
ENV APPSODY_RUN_ON_CHANGE="swift run"
ENV APPSODY_RUN_KILL=true

# Allow remote debugging. The 'appsody debug' command must include the following
# flag: --docker-options "--cap-add=SYS_PTRACE --security-opt seccomp=unconfined"
# FIXME: define this in the appropriate Appsody env var once available.
ENV APPSODY_DEBUG="swift build && echo \"Ready to debug\" && lldb-server platform --listen '*:1234' --min-gdbserver-port 5000 --max-gdbserver-port 5001 --server"
ENV APPSODY_DEBUG_ON_CHANGE="swift build && echo \"Ready to debug\""
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="swift test"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

ENV APPSODY_PROJECT_DIR=/project

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config
WORKDIR /project/user-app

ENV PORT=8080

EXPOSE 8080
EXPOSE 1234
EXPOSE 5000
