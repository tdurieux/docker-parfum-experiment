FROM golang:latest
# Expose default port
EXPOSE 3000

# gin is for dev monitoring
# RUN go-wrapper download github.com/codegangsta/gin
# RUN go-wrapper install github.com/codegangsta/gin

# Copy the local package files to the container’s workspace.
ADD . /go/src/github.com/datatogether/content
# WORKDIR /go/src/github.com/datatogether/content
# CMD ["gin", "-i"]

# Install api binary globally within container 
RUN go install github.com/datatogether/content
# Set binary as entrypoint
ENTRYPOINT /go/bin/content



