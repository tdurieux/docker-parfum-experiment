FROM python:2.7
ADD . /code
WORKDIR /code
RUN apt-get update
RUN apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUn apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD python app.py