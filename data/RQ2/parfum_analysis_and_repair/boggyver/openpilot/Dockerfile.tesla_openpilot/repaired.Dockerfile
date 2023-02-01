FROM ghcr.io/boggyver/openpilot-base:latest

ENV PYTHONUNBUFFERED 1

ENV OPENPILOT_PATH /home/boggyver/openpilot/
ENV PYTHONPATH ${OPENPILOT_PATH}:${PYTHONPATH}

RUN mkdir -p ${OPENPILOT_PATH}
WORKDIR ${OPENPILOT_PATH}

COPY Pipfile Pipfile.lock $OPENPILOT_PATH
RUN pip install --no-cache-dir pipenv==2020.8.13 && \
    pipenv install --system --deploy --dev --clear && \
    pip uninstall -y pipenv

COPY SConstruct ${OPENPILOT_PATH}

COPY ./pyextra ${OPENPILOT_PATH}/pyextra
COPY ./phonelibs ${OPENPILOT_PATH}/phonelibs
COPY ./site_scons ${OPENPILOT_PATH}/site_scons
COPY ./laika ${OPENPILOT_PATH}/laika
COPY ./laika_repo ${OPENPILOT_PATH}/laika_repo
COPY ./rednose ${OPENPILOT_PATH}/rednose
COPY ./tools ${OPENPILOT_PATH}/tools
COPY ./release ${OPENPILOT_PATH}/release
COPY ./common ${OPENPILOT_PATH}/common
COPY ./opendbc ${OPENPILOT_PATH}/opendbc
COPY ./cereal ${OPENPILOT_PATH}/cereal
COPY ./panda ${OPENPILOT_PATH}/panda
COPY ./selfdrive ${OPENPILOT_PATH}/selfdrive

RUN scons -j$(nproc)