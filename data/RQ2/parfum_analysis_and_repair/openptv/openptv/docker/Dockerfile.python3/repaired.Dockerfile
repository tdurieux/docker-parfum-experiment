# A Dockerfile for an Ubuntu machine that can compile liboptv and the Cython extensions

FROM python:3.7-stretch

RUN apt-get update
RUN apt-get --assume-yes -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get --assume-yes -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
# RUN apt-get --assume-yes install python-pip
# RUN apt-get --assume-yes install python3
# RUN pip install virtualenv
RUN python3 -m venv /env