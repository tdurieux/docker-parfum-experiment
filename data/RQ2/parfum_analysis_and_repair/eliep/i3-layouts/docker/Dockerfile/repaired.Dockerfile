FROM python:3.7-buster

RUN echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup

RUN echo 'deb http://http.us.debian.org/debian/ testing non-free contrib main' >> /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -t testing install -y \
    gcc-8-base \
    i3-wm \
    xvfb \
    xdotool \
    -o APT::Immediate-Configure=0 && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src

COPY requirements.txt ./
RUN pip install --no-cache-dir flake8 pytest python-xlib
RUN pip install --no-cache-dir -r requirements.txt
