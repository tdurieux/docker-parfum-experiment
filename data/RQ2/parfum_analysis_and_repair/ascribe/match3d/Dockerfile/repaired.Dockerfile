FROM python:2.7

# blender
ENV BLENDER_MAJOR 2.76
ENV BLENDER_VERSION 2.76b
ENV BLENDER_BZ2_URL http://mirror.cs.umn.edu/blender.org/release/Blender$BLENDER_MAJOR/blender-$BLENDER_VERSION-linux-glibc211-x86_64.tar.bz2

RUN apt-get update && apt-get install --no-install-recommends -y libgl1-mesa-dev libglu1-mesa libxi6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y autoremove && rm -rf /var/lib/apt/lists/*
 RUN mkdir -p /usr/local/blender
RUN curl -f -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2
RUN tar -jxvf blender.tar.bz2 -C /usr/local/blender --strip-components=1 && rm blender.tar.bz2
RUN rm blender.tar.bz2
ENV PATH /usr/local/blender:$PATH

# scientific libs
RUN apt-get update && apt-get install --no-install-recommends -y libblas-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy scipy

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY match3d /usr/src/app/match3d
COPY setup.py /usr/src/app/setup.py

RUN pip install --no-cache-dir -e .[dev]
