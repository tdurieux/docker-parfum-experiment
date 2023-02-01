# AIPlanner - Deep Learning Financial Planner
# Copyright (C) 2019-2021 Gordon Irlam
#
# All rights reserved. This program may not be used, copied, modified,
# or redistributed without permission.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.

FROM aiplanner-base-deps

RUN groupadd -r syslog \
    && groupadd -g 1000 aiplanner \
    && useradd -u 1000 -g aiplanner -m -s /bin/bash aiplanner
    # syslog group needed by logrotate.
    # aiplanner uid and gid chosen to map to ubuntu:ubuntu so can write to shared ~/aiplanner-data directory.