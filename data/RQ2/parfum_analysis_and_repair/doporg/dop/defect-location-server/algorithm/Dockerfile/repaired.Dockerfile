FROM python:3.9.1

ADD . /code
WORKDIR /code
RUN pip3 install --no-cache-dir -r requirements.txt && \
    apt-get install -y --no-install-recommends git && \
    mkdir /code/src/defect_features/utils/data_tmp && \
    mkdir /code/src/defect_features/report && \
    mkdir /code/src/train && rm -rf /var/lib/apt/lists/*;

CMD ["python", "/code/src/app.py"]