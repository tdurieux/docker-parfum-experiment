FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y build-essential cmake git gdb valgrind python-dev libcap-dev python-pip python-virtualenv hardening-includes gnupg libattr1-dev && rm -rf /var/lib/apt/lists/*;
