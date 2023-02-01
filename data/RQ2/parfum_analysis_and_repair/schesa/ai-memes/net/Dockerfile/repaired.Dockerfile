FROM python:3.7

RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir tqdm
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir matplotlib

RUN pip install --no-cache-dir jupyterlab

RUN mkdir /app
WORKDIR /app
# ADD . /app


EXPOSE 8888

CMD jupyter lab --ip=0.0.0.0 --port=8888 --allow-root
# CMD bash
# CMD ["python", "/app/main.py"]