FROM debian:testing

RUN apt-get update -qy && apt-get install --no-install-recommends python3-pip -qy && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir tensorflow==1.4.1 flask flask-cors gunicorn

RUN mkdir -p /funk-generator/
ADD . /funk-generator/
WORKDIR /funk-generator/

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
