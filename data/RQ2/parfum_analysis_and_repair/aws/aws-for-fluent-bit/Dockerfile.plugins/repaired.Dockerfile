FROM public.ecr.aws/amazonlinux/amazonlinux:latest
RUN curl -f -sL -o /bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
RUN chmod +x /bin/gimme
RUN yum upgrade -y && yum install -y tar gzip git make gcc && rm -rf /var/cache/yum
ENV HOME /home
RUN /bin/gimme 1.17.9
ENV PATH ${PATH}:/home/.gimme/versions/go1.17.9.linux.arm64/bin:/home/.gimme/versions/go1.17.9.linux.amd64/bin
RUN go version
ENV GO111MODULE on
RUN go env -w GOPROXY=direct

ARG KINESIS_PLUGIN_CLONE_URL=https://github.com/aws/amazon-kinesis-streams-for-fluent-bit.git
ARG KINESIS_PLUGIN_TAG=v1.9.0
ARG KINESIS_PLUGIN_BRANCH=""
ARG FIREHOSE_PLUGIN_CLONE_URL=https://github.com/aws/amazon-kinesis-firehose-for-fluent-bit.git
ARG FIREHOSE_PLUGIN_TAG=v1.6.1
ARG FIREHOSE_PLUGIN_BRANCH=""
ARG CLOUDWATCH_PLUGIN_CLONE_URL=https://github.com/aws/amazon-cloudwatch-logs-for-fluent-bit.git
ARG CLOUDWATCH_PLUGIN_TAG=v1.8.0
ARG CLOUDWATCH_PLUGIN_BRANCH=""

# Kinesis Streams

RUN git clone $KINESIS_PLUGIN_CLONE_URL /kinesis-streams
WORKDIR /kinesis-streams
RUN if [ -n "$KINESIS_PLUGIN_BRANCH" ];then git fetch --all && git checkout $KINESIS_PLUGIN_BRANCH && git remote -v;fi
RUN if [ -z "$KINESIS_PLUGIN_BRANCH" ];then git fetch --all --tags && git checkout tags/$KINESIS_PLUGIN_TAG -b $KINESIS_PLUGIN_TAG && git describe --tags;fi
RUN go mod download
RUN make release

# Firehose

RUN git clone $FIREHOSE_PLUGIN_CLONE_URL /kinesis-firehose
WORKDIR /kinesis-firehose
RUN if [ -n "$FIREHOSE_PLUGIN_BRANCH" ];then git fetch --all && git checkout $FIREHOSE_PLUGIN_BRANCH && git remote -v;fi
RUN if [ -z "$FIREHOSE_PLUGIN_BRANCH" ];then git fetch --all --tags && git checkout tags/$FIREHOSE_PLUGIN_TAG -b $FIREHOSE_PLUGIN_TAG && git describe --tags;fi
RUN go mod download
RUN make release

# CloudWatch

RUN git clone $CLOUDWATCH_PLUGIN_CLONE_URL /cloudwatch
WORKDIR /cloudwatch
RUN if [ -n "$CLOUDWATCH_PLUGIN_BRANCH" ];then git fetch --all && git checkout $CLOUDWATCH_PLUGIN_BRANCH && git remote -v;fi
RUN if [ -z "$CLOUDWATCH_PLUGIN_BRANCH" ];then git fetch --all --tags && git checkout tags/$CLOUDWATCH_PLUGIN_TAG -b $CLOUDWATCH_PLUGIN_TAG && git describe --tags;fi
RUN go mod download
RUN make release
