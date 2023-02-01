FROM python:3
RUN git clone https://github.com/univ-of-utah-marriott-library-apple/python-jamf
WORKDIR python-jamf
RUN git checkout main && \
    git describe --tags > jamf/VERSION && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir keyrings.alt && \
    python setup.py install
ENTRYPOINT /bin/bash