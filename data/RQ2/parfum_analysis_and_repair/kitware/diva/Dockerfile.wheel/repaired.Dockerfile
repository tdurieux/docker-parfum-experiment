# ** NOTE ** Currently this Dockerfile depends on a non-public Kwiver
# Docker image (due to pending changes in Kwiver)
FROM kitware/kwiver:_wheel

RUN pip3 install --no-cache-dir numpy scipy setuptools scikit-build

RUN git clone https://github.com/Kitware/DIVA /diva \
    && cd diva

RUN cd diva/python \
    && python3 setup.py bdist_wheel -- -- -j$(nproc)
