FROM quay.io/pypa/manylinux2014_x86_64

RUN yum install -y openssl-devel libzstd-devel libcurl-devel && rm -rf /var/cache/yum

WORKDIR /root

ENV PATH=/opt/python/cp310-cp310/bin:$PATH

RUN pip install --no-cache-dir cmake

COPY core ./core
COPY python ./python
COPY scripts ./scripts

RUN pip install --no-cache-dir -r python/requirements_build.txt

ENV VERSION_STRING=0.0
# RUN pip wheel ./python --no-deps -w ./wheelhouse/ --build-option --bdist-dir=./temp-build
# RUN cd python ; python setup.py build --build-base ../temp-build
# RUN cd python ; python setup.py egg_info --egg-base ../temp-build
# RUN cd python ; python setup.py bdist_wheel --dist-dir ../wheelhouse/
RUN cd python ; python setup.py build --build-base ../temp-build \
                                egg_info --egg-base ../temp-build \
                                bdist_wheel --dist-dir ../wheelhouse/

RUN auditwheel repair wheelhouse/*.whl -w ./wheelhouse

ENTRYPOINT ["bash", "-c", "cp wheelhouse/*.whl /io/"]