ARG PYTHON_VERSION
FROM python:$PYTHON_VERSION-slim-buster

LABEL description="Robot Framework in a Python 3 slim-buster based Docker image"

ARG UNAME="robot"
ARG GNAME="robot"
ARG UHOME="/home/robot"
ARG HOST_UID=1000
ARG HOST_GID=1000
ARG SHELL="/bin/bash"

RUN addgroup --system \
  --gid ${HOST_GID} \
  ${GNAME}

RUN adduser --system \
  --uid ${HOST_UID} \
  --ingroup ${GNAME} \
  --disabled-password \
  --home ${UHOME} \
  --shell ${SHELL} \
  ${UNAME}

USER ${UNAME}
WORKDIR ${UHOME}

ENV VIRTUAL_ENV=${UHOME}/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install --no-cache-dir --upgrade pip

ARG RF_VERSION
RUN pip3 install --no-cache-dir robotframework==$RF_VERSION

ENTRYPOINT ["python3", "-m", "robot.run", "--outputdir", "results"]