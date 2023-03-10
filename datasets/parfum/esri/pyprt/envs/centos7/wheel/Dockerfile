ARG REGISTRY=''
ARG BASE_TAG=''
FROM ${REGISTRY}pyprt-base:${BASE_TAG}

ARG PY_VER
ARG USER_ID
ARG GROUP_ID

RUN yum install -y rh-python${PY_VER//./}-python rh-python${PY_VER//./}-python-devel rh-python${PY_VER//./}-python-pip

# this container works with mounted host directories
# we create a user with matching uid/gid to avoid permissions issues
# inspired by https://vsupalov.com/docker-shared-permissions/
RUN groupadd --gid $GROUP_ID user
RUN useradd --uid $USER_ID --gid $GROUP_ID user
USER user

# also see https://github.com/sclorg/devtoolset-container
RUN echo "unset BASH_ENV PROMPT_COMMAND ENV && source scl_source enable devtoolset-9" >> /tmp/scl_enable
ENV BASH_ENV=/tmp/scl_enable ENV=/tmp/scl_enable PROMPT_COMMAND=". /tmp/scl_enable"

WORKDIR /tmp/pyprt
COPY envs/centos7/wheel/requirements-py${PY_VER}.txt ./requirements.txt

ENV VIRTUAL_ENV=/tmp/pyprt-venv
RUN source scl_source enable rh-python${PY_VER//./} && python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m pip install --no-cache-dir --upgrade pip \
	&& python -m pip install --no-cache-dir --upgrade wheel \
	&& python -m pip install --no-cache-dir -r requirements.txt
