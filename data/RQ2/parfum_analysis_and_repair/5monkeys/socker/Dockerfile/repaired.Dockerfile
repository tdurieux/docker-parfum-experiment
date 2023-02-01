FROM python:3.4-onbuild

EXPOSE 8765

RUN apt-get update && apt-get -y --no-install-recommends install wamerican && rm -rf /var/lib/apt/lists/*;
RUN python setup.py develop

ENTRYPOINT ["socker"]
