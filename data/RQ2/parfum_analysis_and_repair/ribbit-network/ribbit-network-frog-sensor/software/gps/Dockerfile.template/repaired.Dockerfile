# The MIT License (MIT)
#
# Copyright (c) 2021 Keenan Johnson
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

FROM balenalib/%%BALENA_MACHINE_NAME%%-python:3.9-build AS build

# cargo for `pip install cryptography`, a transitive dependency of balena-sdk
RUN install_packages \
    gpsd \
    gpsd-clients \
    dbus \
    cargo

# Set up and activate the virtualenv
RUN python -m venv /usr/venv
ENV PATH="/usr/venv/bin:$PATH" VIRTUAL_ENV=/usr/venv

# Prepare our Python toolchain
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir pip --upgrade

# Set our working directory
WORKDIR /usr/src/
# Copy in just enough to install dependencies
COPY pyproject.toml poetry.lock ./
# Install Python packages; dependencies from pyproject.toml via poetry-core / PEP 517
# Create an empty gpsd.py so that pip is not confused
RUN touch gpsd.py && pip install --no-cache-dir .
# Save a tiny amount of space: we don't need `wheel` at runtime
# We also don't need our own package in the virtualenv, we'll run from source
RUN pip uninstall -y wheel gpsd
# Shipping .pyc files doesn't gain us anything, and it costs space
RUN find /usr/venv -name '*.pyc' -delete

########################
# END OF `build` STAGE #
########################

FROM balenalib/%%BALENA_MACHINE_NAME%%-python:3.9-run

RUN install_packages -y --no-install-recommends \
    # Runtime dependencies
    gpsd \
    gpsd-clients \
    dbus \
    # Convenience tools
    vim-tiny

# Grab the virtualenv and activate it
COPY --from=build /usr/venv /usr/venv
ENV PATH="/usr/venv/bin:$PATH" VIRTUAL_ENV=/usr/venv

# Get the source
WORKDIR /usr/src/
COPY . ./

CMD python gpsd.py
