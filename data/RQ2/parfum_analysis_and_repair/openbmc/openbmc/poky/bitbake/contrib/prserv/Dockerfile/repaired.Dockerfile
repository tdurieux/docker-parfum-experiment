# SPDX-License-Identifier: MIT
#
# Copyright (c) 2022 Daniel Gomez <daniel@qtec.com>
#
# Dockerfile to build a bitbake PR service container
#
# From the root of the bitbake repository, run:
#
#   docker build -f contrib/prserv/Dockerfile . -t prserv
#
# Running examples:
#
# 1. PR Service in RW mode, port 18585:
#
# docker run --detach --tty \
# --env PORT=18585 \
# --publish 18585:18585 \
# --volume $PWD:/var/lib/bbprserv \
# prserv
#
# 2. PR Service in RO mode, default port (8585) and custom LOGFILE:
#
# docker run --detach --tty \
# --env DBMODE="--read-only" \
# --env LOGFILE=/var/lib/bbprserv/prservro.log \
# --publish 8585:8585 \
# --volume $PWD:/var/lib/bbprserv \
# prserv
#