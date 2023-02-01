FROM tiangolo/uwsgi-nginx-flask:python3.6

COPY indel_analysis /app/indel_analysis

RUN apt update && apt install --no-install-recommends -y cmake && \
    cd /app/indel_analysis/indelmap && \
    cmake . -DINDELMAP_OUTPUT_DIR=/usr/local/bin && \
    make && make install && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /app/requirements.txt

COPY . /app
COPY server/uwsgi.ini /app

RUN cd /app/indel_prediction && pip install --no-cache-dir . && \
    cd /app/selftarget_pyutils && pip install --no-cache-dir .


ENV INDELGENTARGET_EXE /usr/local/bin/indelgentarget
ENV LISTEN_PORT 8006
ENV PYTHONPATH=/

EXPOSE 8006

