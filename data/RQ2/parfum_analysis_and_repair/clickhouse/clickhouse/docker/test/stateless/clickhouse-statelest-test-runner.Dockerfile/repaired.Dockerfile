# Since right now we can't set volumes to the docker during build, we split building container in stages:
# 1. build base container
# 2. run base conatiner with mounted volumes
# 3. commit container as image
FROM ubuntu:20.04 as clickhouse-test-runner-base

# A volume where directory with clickhouse packages to be mounted,
# for later installing.