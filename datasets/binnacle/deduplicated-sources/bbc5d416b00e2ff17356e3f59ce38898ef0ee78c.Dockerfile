FROM drydock-prod.workiva.net/workiva/smithy-runner-golang:121185 as build

ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
WORKDIR /go/src/github.com/Workiva/go-datastructures/
ADD . /go/src/github.com/Workiva/go-datastructures/

RUN mkdir /root/.ssh && \
    echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts" && \
    chmod 700 /root/.ssh/ && \
    umask 0077 && echo "$GIT_SSH_KEY" >/root/.ssh/id_rsa && \
    eval "$(ssh-agent -s)" && ssh-add /root/.ssh/id_rsa

ARG GOPATH=/go/
ENV PATH $GOPATH/bin:$PATH
RUN git config --global url.git@github.com:.insteadOf https://github.com
RUN echo "Starting the script section" && \
		glide install && \
		echo "script section completed"

ARG BUILD_ARTIFACTS_DEPENDENCIES=/go/src/github.com/Workiva/go-datastructures/glide.lock

FROM scratch
