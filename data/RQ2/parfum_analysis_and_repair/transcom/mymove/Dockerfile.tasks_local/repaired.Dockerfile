###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e  as builder

ENV CIRCLECI=true

COPY --chown=circleci:circleci . /home/circleci/project
WORKDIR /home/circleci/project

RUN make clean
RUN make bin/rds-ca-2019-root.pem
RUN rm -f pkg/assets/assets.go && make pkg/assets/assets.go
RUN make server_generate
RUN rm -f bin/milmove-tasks && make bin/milmove-tasks

#########
# FINAL #
#########

# hadolint ignore=DL3007