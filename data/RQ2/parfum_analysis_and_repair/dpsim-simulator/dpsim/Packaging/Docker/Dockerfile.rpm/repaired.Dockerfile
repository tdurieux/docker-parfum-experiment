# sogno/dpsim:dev is built by dpsim-git/Packaging/Docker/Dockerfile.dev
ARG BASE_IMAGE=sogno/dpsim:dev
ARG CI
ARG CI_COMMIT_SHA
ARG CI_COMMIT_REF_NAME
ARG CI_COMMIT_TAG

FROM ${BASE_IMAGE} AS builder

COPY . /dpsim/

RUN rm -rf /dpsim/build && mkdir /dpsim/build
WORKDIR /dpsim/build

RUN cmake -DBUILD_EXAMPLES=OFF -DCPACK_GENERATOR=RPM ..
RUN make -j$(nproc) package

FROM fedora:29

LABEL \
	org.label-schema.schema-version = "1.0.0" \
	org.label-schema.name = "DPsim" \
	org.label-schema.license = "MPL 2.0" \
	org.label-schema.url = "http://dpsim.fein-aachen.org/" \
	org.label-schema.vcs-url = "https://github.com/sogno-platform/dpsim"

COPY --from=builder /dpsim/build/*.rpm /tmp
RUN dnf -y install /tmp/*.rpm

ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Remove this part in the future and use dedicated jupyter Dockerfile
# Activate Jupyter extensions
ADD requirements-jupyter.txt .
RUN pip3 install --no-cache-dir -r requirements-jupyter.txt
RUN dnf -y --refresh install npm
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Copy Example materials
RUN mkdir dpsim
COPY --from=builder /dpsim/Examples /dpsim/
RUN find /dpsim \
	-name conftest.py -o \
	-name "*.yml" -o \
	-name CMakeLists.txt \
	-exec rm {} \;

WORKDIR /dpsim
EXPOSE 8888
CMD [ "jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--LabApp.token=3adaa57df44cea75e60c0169e1b2a98ae8f7de130481b5bc" ]
