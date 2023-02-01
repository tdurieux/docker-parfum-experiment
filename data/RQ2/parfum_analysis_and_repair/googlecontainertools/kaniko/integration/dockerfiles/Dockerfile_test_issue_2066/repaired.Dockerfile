FROM ubuntu:focal as base
RUN apt update
RUN apt install --no-install-recommends -y libbsd0 && rm -rf /var/lib/apt/lists/*;
RUN apt remove -y libbsd0
RUN apt install --no-install-recommends -y libbsd0 && rm -rf /var/lib/apt/lists/*;
RUN ls -al /usr/lib/x86_64-linux-gnu/libbsd.so.0

FROM base as b
# Fails on main@28432d3c before #2066, the symlink is not existing here.
RUN ls -al /usr/lib/x86_64-linux-gnu/libbsd.so.0
