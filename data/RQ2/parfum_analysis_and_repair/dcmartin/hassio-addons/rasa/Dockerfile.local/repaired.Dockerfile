FROM alpine:3.4

RUN apk --update-cache --no-cache add gcc gfortran python python-dev py-pip build-base wget freetype-dev libpng-dev pkgconfig
RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --update-cache --no-cache add openblas-dev

# RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

# install python
RUN apk add --no-cache python3 py-pip
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pkg-config

RUN apk add --no-cache libpng freetype libstdc++ python py-pip
RUN apk add --no-cache --virtual .build-deps \
	    gcc \
	    build-base \
	    python-dev \
	    libpng-dev \
	    musl-dev \
	    freetype-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir freetype-dev
RUN pip install --no-cache-dir matplotlib
RUN apk del .build-deps

RUN pip install --no-cache-dir --trusted-host pypi.org --trusted-host scipy
RUN pip install --no-cache-dir pandas

# install RASA NLU
RUN pip install --no-cache-dir rasa_nlu
RUN pip install --no-cache-dir rasa_nlu[spacy]
RUN python -m spacy download en_core_web_md
RUN python -m spacy link en_core_web_md en

# RASA setup
ARG RASADIR=/usr/local/rasa
ARG PROJECTS=projects
ARG CONFIG=config_spacey.yml
ARG DATASRC="https://raw.githubusercontent.com/RasaHQ/rasa_nlu/master/data/examples/rasa/demo-rasa.json"
ARG DATA=rasa.json

RUN mkdir -p "${RASADIR}" && chmod 777 "${RASADIR}"
RUN mkdir -p "${RASADIR}/${PROJECTS}" && chmod 777 "${PROJECTS}"

COPY "${CONFIG}" "${RASADIR}/${CONFIG}"

RUN wget "${DATASRC}" -o "${RASADIR}/${DATA}"

COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
