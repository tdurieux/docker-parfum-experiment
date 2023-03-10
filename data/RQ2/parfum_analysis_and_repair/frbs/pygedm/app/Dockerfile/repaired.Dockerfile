FROM python:3.8-slim-buster
RUN apt-get update && apt-get install --no-install-recommends build-essential git gfortran f2c pkg-config libhdf5-dev wget -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /app
RUN mkdir /app/data
COPY ./app.py /app/app.py
COPY ./requirements.txt /app/requirements.txt
COPY ./assets/* /app/assets/
WORKDIR /app

RUN pip3 install --no-cache-dir -r requirements.txt

# DASH APP
RUN wget 'https://zenodo.org/record/5084269/files/skymap.h5?download=1' -O /app/data/skymap.h5
EXPOSE 8050/tcp
CMD gunicorn -w 8 -b 0.0.0.0:8050 app:server


