#
# Build the docker image
# $ docker build -t user/dcrdex -f client/Dockerfile .
#
# Create docker volume to store client data
# $ docker volume create --name=dcrdex_data
#
# Run the docker image, mapping web access port.
# $ docker run -d --rm -p 127.0.0.1:5758:5758 -v dcrdex_data:/root/.dexc user/dcrdex
#

# frontend build
FROM node:16 AS nodebuilder
WORKDIR /root/dex
COPY . .
WORKDIR /root/dex/client/webserver/site/
RUN npm clean-install
RUN npm run build

# dexc binary build
FROM golang:1.18 AS gobuilder
COPY --from=nodebuilder /root/dex/ /root/dex/
WORKDIR /root/dex/client/cmd/dexc/
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build
WORKDIR /root/dex/client/cmd/dexcctl/
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build

# Final image