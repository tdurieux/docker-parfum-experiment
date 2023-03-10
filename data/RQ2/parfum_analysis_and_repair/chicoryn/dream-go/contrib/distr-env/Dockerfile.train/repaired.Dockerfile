FROM dream_go/base:latest
FROM tensorflow/tensorflow:1.15.5-gpu-py3
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -q -r /tmp/requirements.txt
RUN mkdir -p /app /app/data /app/models

COPY .staging/train/. /app/
COPY --from=0 /app/libdg_go.so /app/libdg_go.so
COPY dg_storage.py /app/dg_storage.py
COPY run_train.py /app/run_train.py
COPY google-storage-auth.json /app/google-storage-auth.json
RUN pip install --no-cache-dir -q -r /app/requirements.txt

ARG GIT_REV
ENV GOOGLE_APPLICATION_CREDENTIALS /app/google-storage-auth.json
ENV GIT_REV $GIT_REV
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/lib/python3.6/dist-packages/tensorflow_core"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/app/libdg_tf"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/app"

WORKDIR /app
CMD /app/run_train.py
