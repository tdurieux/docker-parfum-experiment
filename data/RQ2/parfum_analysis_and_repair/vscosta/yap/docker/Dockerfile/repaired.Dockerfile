# Use an official Python runtime as a parent image
FROM ubuntu AS yap

ENV TZ=Europe/Lisbon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



# Set the working directory to /app
WORKDIR /app

RUN apt update && apt -y upgrade && apt -y --no-install-recommends install \

    git gcc g++ make cmake \

    autotools-dev automake autoconf perl-base m4 doxygen flex bison \

    libreadline-dev libgmp-dev \

    openmpi-bin libopenmpi-dev \

    swig \

    python3 python3-dev python3-numpy python3-numpy-dev \

    python3-pip python3-wheel python3-setuptools \

    python3-notebook \

    libgecode-dev \

    r-cran-rcpp \

    libxml2-dev libraptor2-dev \
    openjdk-11-jdk-headless && rm -rf /var/lib/apt/lists/*;


#yap binary

RUN git clone https://github.com/vscosta/cudd.git /app/cudd \
    && cd /app/cudd \
    && aclocal\
    && automake \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr --enable-shared --enable-obj --enable-dddmp && make -j install && cd ..

RUN  git clone https://github.com/vscosta/yap /app/yap --depth=6\
    && mkdir -p /app/yap/build\
    && cd /app/yap/build\
    && cmake .. -DWITH_DOXYGEN=1  -DWITH_PACKAGES=1 -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    && cmake --build . --parallel --target install


RUN  git clone https://github.com/vscosta/doxygen-yap.git /app/doxygen-yap &&\
    cd /app/doxygen-yap &&\
    mkdir -p build&&\
    cd build&&\
    cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr && cmake --build . --target install --parallel

RUN  mkdir -p /app/yap/build && \
    cd /app/yap/build &&\
    doxygen-yap  Doxyfile.dox

#Python extras
RUN apt-get -y --no-install-recommends install curl \
    && curl -fsSL https://deb.nodesource.com/setup_17.x|bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && cd /app/yap/build/packages/python/yap4py \
    && pip3 install --no-cache-dir jupyterlab \
    && pip3 install --no-cache-dir . \
    && cd /app/yap/packages/python/yapkernel \
      && pip3 install --no-cache-dir . \
    && python3 -m yapkernel.kernelspec && rm -rf /var/lib/apt/lists/*;


RUN python3 -m jupyter lab build\
    &&mkdir /usr/local/share/jupyter/lab/staging/node_modules/codemirror/mode/prolog\
    &&cp /app/yap/misc/editors/codemirror/meta.js /usr/local/share/jupyter/lab/staging/node_modules/codemirror/mode/meta.js\
    &&cp /app/yap/misc/editors/codemirror/prolog.js /usr/local/share/jupyter/lab/staging/node_modules/codemirror/mode/prolog\
    &&python3 -m jupyter lab build\
    &&cp /app/yap/misc/tut.ipynb /app


#R extras
RUN cd /app/yap/build \
    && cmake --build . --target YAP4R
RUN cd /app/yap/build \
    &&  R CMD INSTALL packages/real/yap4r

# Make port 80 available to the world outside this container
EXPOSE 22 80 8888

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["jupyter", "lab", "--port=8888", "--no-browser","--NotebookApp.token=''","--NotebookApp.password=''", "--ip=0.0.0.0", "--allow-root", "tut.ipynb" ]

