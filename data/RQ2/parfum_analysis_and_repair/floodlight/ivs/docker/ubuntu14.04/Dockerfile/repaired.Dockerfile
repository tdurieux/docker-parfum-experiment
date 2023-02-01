FROM ubuntu:14.04
MAINTAINER Rich Lane <rlane@bigswitch.com>
RUN apt-get update && apt-get install --no-install-recommends -y build-essential pkg-config libnl-3-dev libnl-route-3-dev libnl-genl-3-dev python debhelper ccache && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcap2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpcap0.8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
