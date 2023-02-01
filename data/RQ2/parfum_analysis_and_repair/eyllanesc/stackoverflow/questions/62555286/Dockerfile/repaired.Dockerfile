FROM ubuntu:latest

RUN apt-get update && \
    apt-get autoclean

RUN apt-get update && apt-get install \
    -y --no-install-recommends python3 python3-virtualenv && rm -rf /var/lib/apt/lists/*;

ENV USERNAME=qt_user
RUN useradd -ms /bin/bash $USERNAME

ENV XDG_RUNTIME_DIR=/run/user/1000
RUN mkdir -p -m 0700 $XDG_RUNTIME_DIR && chown -R $USERNAME:users $XDG_RUNTIME_DIR

WORKDIR /home/$USERNAME

ENV VIRTUAL_ENV=/home/$USERNAME/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies:
COPY requirements.txt .
RUN pip install --no-cache-dir -vvv -r requirements.txt

ENV QT_VERSION=5.15.0
ENV QT_OUTPUT_DIR=/home/$USERNAME/qt
RUN python -m aqt install $QT_VERSION linux desktop --outputdir $QT_OUTPUT_DIR

RUN apt-get update && apt-get install \
    -y --no-install-recommends \
    build-essential \
    libgl-dev \
    libglib2.0-0 \
    libgssapi-krb5-2 && rm -rf /var/lib/apt/lists/*;

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/Lima /etc/localtime

RUN apt-get update && apt-get install \
    -y --no-install-recommends \
    libsqlite3-dev \
    libsqlite3-mod-spatialite && rm -rf /var/lib/apt/lists/*;

COPY qsqlite qsqlite

COPY *.py /home/$USERNAME/

RUN mkdir build && \
    cd build && \
    ../qt/5.15.0/gcc_64/bin/qmake ../qsqlite/ && \
    make && \
    cd .. && \
    cp build/libqsqlite.so .

USER $USERNAME
