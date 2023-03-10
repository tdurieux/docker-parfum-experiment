#
# Copyright (c) .NET Foundation and contributors. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#

FROM opensuse:13.2

# Install the base toolchain we need to build anything (clang, cmake, make and the like)
# this does not include libraries that we need to compile different projects, we'd like
# them in a different layer.
RUN zypper -n install binutils \
              cmake \
              which \
              gcc \
              llvm-clang \
              tar \
              ncurses-utils \
              curl \
              git \
              sudo && \
    ln -s /usr/bin/clang++ /usr/bin/clang++-3.5 && \
    zypper clean -a

# Dependencies of CoreCLR and CoreFX.  We need to add an additional repository to get lttng.
RUN zypper addrepo -G http://download.opensuse.org/repositories/devel:/tools:/lttng/openSUSE_13.2/devel:tools:lttng.repo && \
    zypper refresh && \
    zypper -n remove krb5-mini && \
    zypper -n install libunwind \
                      libicu \
                      lttng-ust \
                      libuuid1 \
                      libopenssl1_0_0 \
                      libcurl4 \
                      krb5 && \
    zypper clean -a

# Setup User to match Host User, and give superuser permissions
ARG USER_ID=0
RUN useradd -m code_executor -u ${USER_ID} -g wheel
RUN echo 'code_executor ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# With the User Change, we need to change permissions on these directories
RUN chmod -R a+rwx /usr/local
RUN chmod -R a+rwx /home
RUN chmod -R 755 /usr/lib/sudo

# Set user to the one we just created
USER ${USER_ID}

# Set working directory