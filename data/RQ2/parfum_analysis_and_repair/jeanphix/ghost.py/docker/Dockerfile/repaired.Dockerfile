FROM ubuntu:xenial
ENV PYTHONUNBUFFERED 1
RUN apt-get update
RUN apt-get install --no-install-recommends python3-pip xvfb git software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends software-properties-common -y && \
    add-apt-repository ppa:thopiekar/pyside-git -y && \
    apt-get remove software-properties-common -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends python3-pyside2 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN pip3 install --no-cache-dir xvfbwrapper
RUN pip3 install --no-cache-dir ghost.py --pre
