FROM ngraph_test_base

RUN apt-get install -y bzip2 wget coreutils libjasper1 libjpeg8 libpng12-0

# Get and build Open MPI
RUN wget -q https://www.open-mpi.org/software/ompi/v1.10/downloads/openmpi-1.10.3.tar.gz && \
    tar -xzvf ./openmpi-1.10.3.tar.gz && \
    cd openmpi-1.10.3 && \
    ./configure --prefix=/usr/local/mpi && \
    make -j all && \
    make install && cd .. && \
    rm -rf openmpi-1.10.3 openmpi-1.10.3.tar.gz

# Add Open MPI to path
ENV PATH "/usr/local/mpi/bin:$PATH"
ENV LD_LIBRARY_PATH "/usr/local/mpi/lib:$LD_LIBRARY_PATH"
ENV MPI_ROOT "/usr/local/mpi"

# Get and install CNTK Binary Distribution
ENV CNTK_WHEEL_2_7 https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp27-cp27mu-linux_x86_64.whl
ENV CNTK_WHEEL_3_4 https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp34-cp34m-linux_x86_64.whl
ENV CNTK_WHEEL_3_5 https://cntk.ai/PythonWheel/CPU-Only/cntk-2.2-cp35-cp35m-linux_x86_64.whl
RUN if [ "$(python -c 'import sys; print(sys.version_info[0])')" = "2" ]; then \
    pip install --trusted-host cntk.ai $CNTK_WHEEL_2_7; \
    else \
      if [ "$(python -c 'import sys; print(sys.version_info[1])')" = "4" ]; then \
      pip install $CNTK_WHEEL_3_4; fi;\
      if [ "$(python -c 'import sys; print(sys.version_info[1])')" = "5" ]; then \
      pip install $CNTK_WHEEL_3_5; fi; \
    fi

# necessary for tests/test_walkthrough.py which requires that ngraph is
# importable from an entrypoint not local to ngraph.
ADD . /root/ngraph-test
RUN pip install -e .
