#swarmci
FROM python:3-alpine
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY setup.py /usr/src/app
RUN pip install --no-cache-dir -e .
COPY . /usr/src/app
CMD [ "python", "-m", "swarmci" ]