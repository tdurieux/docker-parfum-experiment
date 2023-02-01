FROM ubuntu:20.04
FROM python:3.8.8

RUN apt-get update
RUN apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /src/requirements.txt
COPY requirements.txt /src/requirements_git.txt

RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pip --upgrade
RUN pip3 install --no-cache-dir Cython

RUN xargs -L 1 pip3 install < /src/requirements.txt
RUN xargs -L 1 pip3 install < /src/requirements_git.txt

WORKDIR /root
RUN python3 --version

