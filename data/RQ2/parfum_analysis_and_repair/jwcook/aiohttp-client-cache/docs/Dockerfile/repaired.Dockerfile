# Readthedocs build container with project dependencies pre-installed
FROM readthedocs/build:8.0
COPY . /src/
RUN pip3 install --no-cache-dir -U /src/[docs,backends]
ENTRYPOINT ["/bin/bash"]
