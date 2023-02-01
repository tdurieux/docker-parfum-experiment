# Build rewardcalculator
FROM golang:1.12-alpine as builder

ARG RC_TAG

RUN apk add --no-cache git make
ADD https://api.github.com/repos/icon-project/rewardcalculator/git/refs/heads/master version.json
RUN git clone --branch $RC_TAG --single-branch https://github.com/icon-project/rewardcalculator.git /rewardcalculator

RUN cd /rewardcalculator && make

# Build T-Bears