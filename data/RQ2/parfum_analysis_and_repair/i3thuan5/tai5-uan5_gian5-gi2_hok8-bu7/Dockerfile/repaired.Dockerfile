FROM i3thuan5/tai5-uan5_gian5-gi2_kang1-ku7:tsuan
MAINTAINER i3thuan5

ARG TOX_ENV

RUN apt-get update && apt-get install --no-install-recommends -y libav-tools libpq-dev wget && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/tai5-uan5_gian5-gi2_hok8-bu7
RUN pip install --no-cache-dir tox
COPY . .
RUN tox --sitepackages -e ${TOX_ENV}
