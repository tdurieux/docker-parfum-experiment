FROM legraina/bcp

# install valgrind
RUN apt-get update && apt-get install --no-install-recommends -y --force-yes --fix-missing valgrind; && rm -rf /var/lib/apt/lists/*; exit 0

# create a user
RUN useradd -ms /bin/bash poly

# Change user
USER poly

# Copy everything
COPY --chown=poly . /home/poly/ns/

# Set the working directory
WORKDIR /home/poly/ns/

# Compile the nurse scheduler
RUN echo "set(BCPDIRDBG /usr/local/Bcp-1.4/build)" > CMakeDefinitionsLists.txt && \
    echo "set(BOOST_DIR /usr/local/include)" >> CMakeDefinitionsLists.txt && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Debug .. && \
    make

# Entrypoint for the nurse scheduler
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "-h" ]
