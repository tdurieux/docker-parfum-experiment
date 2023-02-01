FROM ubuntu:18.04
COPY gnu-koryavov /home/gnu-koryavov

RUN apt update
RUN apt -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install atril && rm -rf /var/lib/apt/lists/*;

RUN ["chmod", "+x", "/home/gnu-koryavov/ci-scripts/tests/test_install.sh"]
RUN ["chmod", "+x", "/home/gnu-koryavov/ci-scripts/tests/test_ubuntu_run.sh"]


