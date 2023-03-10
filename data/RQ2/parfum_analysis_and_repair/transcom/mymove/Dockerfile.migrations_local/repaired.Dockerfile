###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e as builder

ENV CIRCLECI=true

COPY --chown=circleci:circleci . /home/circleci/project
WORKDIR /home/circleci/project

RUN make clean
RUN make bin/rds-ca-2019-root.pem
RUN rm -f pkg/assets/assets.go && make pkg/assets/assets.go
RUN make server_generate
RUN rm -f bin/milmove && make bin/milmove

#########
# FINAL #
#########

FROM alpine:3.15.4

# hadolint ignore=DL3017
RUN apk upgrade --no-cache busybox

COPY --from=builder --chown=root:root /home/circleci/project/bin/rds-ca-2019-root.pem /bin/rds-ca-2019-root.pem
COPY --from=builder --chown=root:root /home/circleci/project/bin/milmove /bin/milmove

COPY migrations/app/schema /migrate/schema
COPY migrations/app/migrations_manifest.txt /migrate/migrations_manifest.txt

# Install tools needed in container
# hadolint ignore=DL3018