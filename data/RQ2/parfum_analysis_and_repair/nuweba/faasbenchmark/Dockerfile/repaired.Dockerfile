FROM golang:1.12.17 as builder

RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go build -o faasbenchmark main.go
RUN go build -o faasbenchmark-tui tui.go

FROM node:13.8.0-stretch

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates curl apt-transport-https lsb-release gnupg wget software-properties-common gcc zip unzip python3 python3-pip && rm -rf /var/lib/apt/lists/*;

# add azure cli repo
RUN curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
	AZ_REPO=$(lsb_release -cs) && \
	echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list

# add dotnet repo
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.asc.gpg && \
	mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
	wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
	mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
	chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
	chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN npm install -g serverless azure-functions-core-tools@3 && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends azure-cli openjdk-8-jdk maven dotnet-sdk-3.1 -y --fix-missing && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app

COPY --from=builder /app/ /app
WORKDIR /app
RUN npm install && npm cache clean --force;

CMD ./faasbenchmark





