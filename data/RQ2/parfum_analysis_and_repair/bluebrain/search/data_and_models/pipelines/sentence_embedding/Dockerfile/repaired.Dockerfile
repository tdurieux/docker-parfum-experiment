# Blue Brain Search is a text mining toolbox focused on scientific use cases.
#
# Copyright (C) 2020  Blue Brain Project, EPFL.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

FROM nvcr.io/nvidia/pytorch:21.06-py3

ENV HTTP_PROXY='http://bbpproxy.epfl.ch:80/'
ENV HTTPS_PROXY='http://bbpproxy.epfl.ch:80/'
ENV http_proxy='http://bbpproxy.epfl.ch:80/'
ENV https_proxy='http://bbpproxy.epfl.ch:80/'

# Update conda, install additional system packages
RUN true \
	&& conda update conda \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y gcc g++ build-essential vim libfontconfig1 && rm -rf /var/lib/apt/lists/*;
RUN conda install -c carta mysqlclient

# Instal BlueBrainSearach -- revision can be a branch, sha, or tag
ARG BBS_REVISION=v0.2.0
ADD . /src
WORKDIR /src
RUN git checkout $BBS_REVISION
# remove ruamel-yaml: https://github.com/pypa/pip/issues/5247#issuecomment-381550610
RUN rm -rf /opt/conda/lib/python3.8/site-packages/ruamel*
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-data_and_models.txt
RUN pip install --no-cache-dir $PWD[data_and_models]
# Force the version of the script training_transformers/train.py
RUN pip install --no-cache-dir transformers==3.4.0


EXPOSE 8888

RUN groupadd -g 999 docker
RUN useradd --create-home --uid 1000 --gid docker bbsuser

WORKDIR /bbs
RUN rm -rf /bbs/tmp
ENTRYPOINT ["/bin/bash"]
