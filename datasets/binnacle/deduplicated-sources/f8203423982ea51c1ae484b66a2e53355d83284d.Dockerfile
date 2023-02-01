# Build concourse smuggler
FROM golang:1.9-alpine
RUN apk add -U git && rm -rf /var/cache/apk/*
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
        go get github.com/redfactorlabs/concourse-smuggler-resource

# Modify the upstream resource
FROM concourse/s3-resource

# Add the smuggler binary compiled previously
COPY --from=0 /go/bin/concourse-smuggler-resource /opt/resource/smuggler

# Rename the old resource commands
RUN mv /opt/resource/check /opt/resource/check.wrapped \
    && mv /opt/resource/in /opt/resource/in.wrapped \
    && mv /opt/resource/out /opt/resource/out.wrapped

# Link the /opt/resource{check,in,out} commands to smuggler
RUN ln /opt/resource/smuggler /opt/resource/check \
    && ln /opt/resource/smuggler /opt/resource/in \
    && ln /opt/resource/smuggler /opt/resource/out

# Add the config file for this resource
ADD ./smuggler.yml /opt/resource/

RUN mkdir -p /opt/resource/bin/

# Install unicreds
ADD https://github.com/Versent/unicreds/releases/download/1.5.1/unicreds_1.5.1_linux_amd64.tar.gz /tmp/
RUN tar -xf /tmp/unicreds_1.5.1_linux_amd64.tar.gz -C /opt/resource/bin/ unicreds && \
    rm -rf  /tmp/unicreds_1.5.1_linux_amd64.tar.gz

# Install spruce
ADD https://github.com/geofffranks/spruce/releases/download/v1.8.15/spruce-linux-amd64 /opt/resource/bin/spruce
RUN chmod +x  /opt/resource/bin/spruce
