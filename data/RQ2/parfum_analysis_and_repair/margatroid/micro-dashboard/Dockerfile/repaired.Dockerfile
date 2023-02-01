FROM golang:1.5.2

# Copy files to workspace
ADD . /go/src/github.com/Margatroid/micro-dashboard
WORKDIR /go/src/github.com/Margatroid/micro-dashboard

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install history@1.17.0 && npm cache clean --force;
RUN npm install && npm cache clean --force;
RUN npm run build

WORKDIR /go/src/github.com/Margatroid/micro-dashboard/dashboard
RUN go get
RUN go install github.com/Margatroid/micro-dashboard/dashboard

ENTRYPOINT /go/bin/dashboard
