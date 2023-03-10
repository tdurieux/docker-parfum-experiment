FROM ubuntu:latest

# install base dependences   
RUN apt-get update && \
    apt-get install --no-install-recommends -y make cmake git curl build-essential m4 sudo gdbserver \
    gdb libreadline-dev bison flex zlib1g-dev tmux emacs25-nox zile zip vim gawk wget && rm -rf /var/lib/apt/lists/*;

# add postgres user and make data dir       
RUN groupadd -r postgres && useradd --no-log-init -r -m -s /bin/bash -g postgres -G sudo postgres
ENV PGDATA /home/postgres/data
RUN /bin/rm -Rf "$PGDATA" && mkdir "$PGDATA"
WORKDIR "/home/postgres"

# get postgres source and compile with debug and no optimization
RUN git clone --branch REL_12_STABLE https://github.com/postgres/postgres.git --depth=1 && \
    cd postgres && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/usr/ \
#    --enable-debug \
#    --enable-depend --enable-cassert --enable-profiling \
#    CFLAGS="-ggdb -Og -g3 -fno-omit-frame-pointer" \
#    CFLAGS="-O3" \
    && make -j 4 && make install

# get GraphBLAS, compile with debug symbols   
RUN curl -f -s -L https://faculty.cse.tamu.edu/davis/GraphBLAS/GraphBLAS-3.1.1.tar.gz | \
    tar zxvf - && cd GraphBLAS-3.1.1 && \
#    sed -i 's/^\/\/ #undef NDEBUG/#undef NDEBUG/g' Source/GB.h && \
#    sed -i 's/^\/\/ #define GB_PRINT_MALLOC 1/#define GB_PRINT_MALLOC 1/g' Source/GB.h && \
    make library \
    CMAKE_OPTIONS='-DCMAKE_BUILD_TYPE=Debug' \
    && make install

RUN git clone --branch 22July2019 https://github.com/GraphBLAS/LAGraph.git && \
    cd LAGraph && \
    make library \
#    CMAKE_OPTIONS='-DCMAKE_BUILD_TYPE=Debug' \
    && make install

RUN curl -f -s -L https://github.com/theory/pgtap/archive/v0.99.0.tar.gz | tar zxvf - && \
    cd pgtap-0.99.0 && make && make install

# chown dependencies   
RUN chown -R postgres:postgres /home/postgres

# put test stuff into pg home       
RUN mkdir "/home/postgres/pggraphblas"
WORKDIR "/home/postgres/pggraphblas"
COPY . .

# RUN mkdir "/home/postgres/LAGraph"
# COPY LAGraph /home/postgres/LAGraph

# RUN cd /home/postgres/LAGraph && \
#     make library \
#     CMAKE_OPTIONS='-DCMAKE_BUILD_TYPE=Debug' \
#     && make install

# make the extension   
RUN make && make install && make clean
RUN ldconfig

# chown just pggraphblas
RUN chown -R postgres:postgres /home/postgres/pggraphblas

# make postgres a sudoer       
RUN echo "postgres ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# start the database           
USER postgres
RUN initdb -D "$PGDATA"
EXPOSE 5432
# wait forever
CMD tail -f /dev/null
