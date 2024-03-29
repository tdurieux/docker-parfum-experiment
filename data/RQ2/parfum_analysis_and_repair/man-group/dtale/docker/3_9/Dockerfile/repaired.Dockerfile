FROM node:10.16.0-alpine as node_build

RUN set -eux \
  ; apk add --no-cache git

COPY . /workspace

WORKDIR /workspace/frontend
RUN set -eux \
  ; yarn install --frozen-lockfile \
  ; yarn cache clean; yarn list --depth=0 \
  ; yarn run lint \
  ; yarn run format \
  ; git diff --name-status ./static \
  ; git diff-files --quiet ./static || (echo 'The files above have not been formatted!' && (exit 1)) \
  ; yarn run test \
  ; ls -lah node_modules \
  ; yarn run build

FROM continuumio/anaconda:latest as python_build

COPY --from=node_build /workspace /workspace

ENV PATH="/opt/conda/bin/:${PATH}"

WORKDIR /workspace
RUN set -eux \
  ; pip install --no-cache-dir six \
  ; pip install --no-cache-dir lxml \
  ; pip install --no-cache-dir black \
  ; pip install --no-cache-dir -r docs/source/requirements.txt \
  ; python setup.py develop \
  ; python setup.py build_sphinx \
  ; black --check setup.py dtale tests \
  ; export TZ=America/New_York \
  ; python setup.py test \
  ; python setup.py bdist_egg

FROM continuumio/anaconda:latest

COPY --from=python_build /workspace/dist/*.egg /app/

WORKDIR /app

RUN set -eux \
  ; . /root/.bashrc \
  ; easy_install "dtale-${VERSION}-py3.9.egg"
