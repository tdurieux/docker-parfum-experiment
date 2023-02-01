FROM python:2.7
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
RUN pip install --no-cache-dir --upgrade pip
COPY . /usr/src/app
RUN pip install --no-cache-dir -r requirements.txt
RUN python setup.py install
CMD mykrobe --help