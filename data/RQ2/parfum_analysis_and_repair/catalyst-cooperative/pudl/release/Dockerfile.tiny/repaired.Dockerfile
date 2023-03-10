# WIP: This is an attempt to make small docker image that
# installs pypi tarball with pip and does not rely on
# conda environment.
# It is unclear whether this will work.

# Step 1: Build pypi tarball from the local source
# FROM treyduskin/python-setuptools AS pudl-source-build
FROM python:3.8 AS pudl-source-build
WORKDIR /pudl/repo
COPY . /pudl/repo
RUN mkdir /pudl/package && mkdir /pudl/src
RUN ./devtools/print_requirements.py > /pudl/package/requirements.txt
RUN python setup.py sdist -d /pudl/package && mv /pudl/package/*tar.gz /pudl/package/pudl.tar.gz
RUN tar xzf /pudl/package/pudl.tar.gz -C /pudl/src --strip-components=1 && rm /pudl/package/pudl.tar.gz
RUN rm -Rf /pudl/repo

# Step 2: install pudl package from the above, also install libsnappy-dev
# because it is needed for the pip install.

FROM python:3.8
RUN apt-get update && apt-get -y --no-install-recommends install libsnappy-dev git && rm -rf /var/lib/apt/lists/*;
COPY --from=pudl-source-build /pudl/package/requirements.txt /tmp/requirements.txt
# RUN --mount=type=cache,mode=0755,target=/root/.cache/pip pip install -r /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
COPY --from=pudl-source-build /pudl /pudl
RUN pip install --no-cache-dir /pudl/package/pudl.tar.gz
WORKDIR /pudl/src


RUN mkdir /pudl/inputs /pudl/outputs
RUN pudl_setup --pudl_in /pudl/inputs --pudl_out /pudl/outputs

VOLUME /pudl/inputs/data
VOLUME /pudl/outputs

ENV PUDL_SETTINGS=/pudl/src/release/settings/release.yml
CMD ["pudl_etl", "-c", "/pudl/src/release/settings/release.yml"]
