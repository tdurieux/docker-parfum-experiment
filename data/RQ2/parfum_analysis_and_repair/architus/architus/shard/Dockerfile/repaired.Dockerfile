FROM ubuntu:18.04

WORKDIR /app
#ENV MAGICK_HOME=/usr
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

#RUN apt install build-base musl-dev python3
#RUN apt install gcc python3-dev build-base wget freetype-dev libpng-dev postgresql-dev libffi-dev libxml2-dev libxslt-dev jpeg-dev
#RUN apt-get install ffmpeg
#RUN apt-get install imagemagi

RUN apt-get -y update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python3.8-dev python3-pip ffmpeg pkg-config cron git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install texlive texlive-latex-extra dvipng && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxml2-dev libxslt-dev python-libxslt1 libpq-dev libffi-dev && rm -rf /var/lib/apt/lists/*;

# Install architus re2 library
RUN git clone https://github.com/architus/re2
WORKDIR /app/re2
RUN make install

# Install pyre2 python library
WORKDIR /app
RUN git clone https://github.com/facebook/pyre2
WORKDIR /app/pyre2
RUN python3.8 setup.py build
RUN python3.8 setup.py install
RUN python3.8 setup.py check

WORKDIR /app
COPY ./shard/requirements.txt /app

# Install any needed packages specified in requirements.txt
ENV GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS 16
RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install wheel
RUN python3.8 -m pip install --trusted-host pypi.python.org --use-deprecated=legacy-resolver -r requirements.txt
#RUN apk del libpng-dev jpeg-dev libffi-dev libxml2-dev python3-dev libxslt-dev freetype-dev

ENV PYTHONIOENCODING UTF-8

# Copy the current directory contents into the container at /app
COPY  ./shard/ /app/
COPY ./lib/python-common /app/lib

# Run app.py when the container launches
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
CMD python3.8 -u bot.py
