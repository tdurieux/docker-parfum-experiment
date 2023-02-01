FROM python:3.7
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code
RUN apt-get install -y --no-install-recommends libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
ADD . /code/