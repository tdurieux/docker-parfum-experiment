FROM python:3.6
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
RUN python setup.py install
RUN nosetests
RUN mritopng --help