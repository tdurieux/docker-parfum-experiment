FROM python:3.6

ARG TZ=Etc/UTC

WORKDIR /omim/

ADD . .

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    libgl1-mesa-dev \
    libsqlite3-dev \
    qt5-default \
    zlib1g-dev \
    tzdata \
    locales-all && rm -rf /var/lib/apt/lists/*;

RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN echo "" | ./configure.sh \
	&& ./tools/unix/build_omim.sh -rs generator_tool

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir werkzeug==0.16.0 \
    SQLAlchemy==1.3.15 \
    -r ./tools/python/airmaps/requirements_dev.txt
