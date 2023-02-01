FROM python:3.7.6

RUN apt-key del 7fa2af80  && \
    rm -f /etc/apt/sources.list.d/cuda*.list && \
    curl -f https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
    -o cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;

ARG LANGUAGE=EN
ENV LANGUAGE ${LANGUAGE}

ARG CONFIG
ARG PORT
ARG SRC_DIR
ARG SED_ARG=" | "

ENV CONFIG=$CONFIG
ENV PORT=$PORT

RUN pip install --no-cache-dir pybind11==2.2.4
RUN pip install --no-cache-dir hdt==2.3

COPY ./annotators/entity_linking_rus/requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt

COPY $SRC_DIR /src

WORKDIR /src
RUN python -m deeppavlov install $CONFIG

RUN sed -i "s|$SED_ARG|g" "$CONFIG"

CMD gunicorn  --workers=1 --timeout 500 server:app -b 0.0.0.0:8075
