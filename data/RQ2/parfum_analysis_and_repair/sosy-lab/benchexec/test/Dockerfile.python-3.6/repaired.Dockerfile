# This file is part of BenchExec, a framework for reliable benchmarking:
# https://github.com/sosy-lab/benchexec
#
# SPDX-FileCopyrightText: 2007-2020 Dirk Beyer <https://www.sosy-lab.org>
#
# SPDX-License-Identifier: Apache-2.0

# This is a Docker image for running the tests.
# It should be pushed to registry.gitlab.com/sosy-lab/software/benchexec/test
# and will be used by CI as declared in .gitlab-ci.yml.
#
# Commands for updating the image:
# docker build -t registry.gitlab.com/sosy-lab/software/benchexec/test:python-3.6 - < test/Dockerfile.python-3.6
# docker push registry.gitlab.com/sosy-lab/software/benchexec/test

FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y \
  lxcfs \
  sudo && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir \
  "coverage[toml] >= 5.0" \
  lxml \
  nose \
  pyyaml
