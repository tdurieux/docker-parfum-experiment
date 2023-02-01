# Local build
FROM gradle:4.10.3-jdk8 AS builder-local

WORKDIR /corda-driver
ADD build /corda-driver/build

FROM builder-local as builder

# Deployment Image 