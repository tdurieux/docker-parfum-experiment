FROM debian
LABEL maintainer="loblab"

#ARG TZ=Asia/Shanghai
#ARG APT_MIRROR=mirrors.163.com
ARG DEBIAN_FRONTED=noninteractive
ARG PYTHON=python3

#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#RUN sed -i "s/deb.debian.org/$APT_MIRROR/" /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install chromium-chromedriver || \
    apt-get -y --no-install-recommends install chromium-driver || \
    apt-get -y --no-install-recommends install chromedriver && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ${PYTHON}-pip && rm -rf /var/lib/apt/lists/*;
RUN $PYTHON -m pip install selenium
RUN apt-get -y --no-install-recommends install curl wget && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/loblab && \
    useradd -d /home/loblab -u 1001 loblab && \
    chown loblab:loblab /home/loblab
USER loblab
WORKDIR /home/loblab
COPY /noip-renew.py /home/loblab/
ENTRYPOINT ["python3", "/home/loblab/noip-renew.py"]
