FROM python:3.6

RUN git clone https://github.com/churchmanlab/genewalk.git && \
    cd genewalk && \
    pip install --no-cache-dir . && \
    python -m genewalk.resources
