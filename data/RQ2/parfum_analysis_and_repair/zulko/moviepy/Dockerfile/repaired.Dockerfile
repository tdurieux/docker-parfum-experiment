FROM python:3

# Install numpy using system package manager
RUN apt-get -y update && apt-get -y --no-install-recommends install ffmpeg imagemagick && rm -rf /var/lib/apt/lists/*;

# Install some special fonts we use in testing, etc..
RUN apt-get -y --no-install-recommends install fonts-liberation && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8 && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL C.UTF-8

ADD . /var/src/moviepy/
#RUN git clone https://github.com/Zulko/moviepy.git /var/src/moviepy
RUN cd /var/src/moviepy/ && pip install --no-cache-dir .[optional]

# modify ImageMagick policy file so that Textclips work correctly.
RUN sed -i 's/none/read,write/g' /etc/ImageMagick-6/policy.xml
