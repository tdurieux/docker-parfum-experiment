# compile environment;
FROM annchain/builder:go1.12 as builder
#copy files;
ADD . /AnnChain
WORKDIR /AnnChain
RUN GO111MODULE="on" GOPROXY="https://goproxy.io" make genesis

# package environment;