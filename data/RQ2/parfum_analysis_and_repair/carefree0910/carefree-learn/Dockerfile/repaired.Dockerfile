FROM nvcr.io/nvidia/pytorch:21.07-py3
WORKDIR /usr/home
COPY . .
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir .[full] && \
    rm -rf ./*