FROM edrixs/edrixs_base
WORKDIR /project

COPY . ./src/edrixs

    # build fortran part of edrixs
RUN export LD_LIBRARY_PATH="/usr/local/lib:\$LD_LIBRARY_PATH" \
    && make -C src/edrixs/src F90=mpif90 LIBS="-L/usr/local/lib -lopenblas -lparpack -larpack" \
    && make install -C src/edrixs/src \
    # build python part of edrixs
    && cd src/edrixs \
    && python setup.py build_ext --library-dirs=/usr/local/lib \
    && pip install . \
    && cd ../../  \
    # set env
    && echo "export PATH=/project/src/edrixs/bin:\$PATH" >> ~/.bashrc  \
    && echo "export PATH=/project/src/edrixs/bin:\$PATH" >> /home/rixs/.bashrc  \
    # copy examples to /home/rixs
    && cp -r src/edrixs/examples /home/rixs/edrixs_examples \
    && chown -R rixs:rixs /home/rixs/edrixs_examples
