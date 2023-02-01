FROM python:3.7.7-slim-buster


RUN pip install --no-cache-dir setuptools==45.0.0
RUN pip install --no-cache-dir pyinstaller

RUN apt-get update ; apt-get install --no-install-recommends -y binutils; rm -rf /var/lib/apt/lists/*; apt-get install --no-install-recommends -y procps
COPY ./dist/* /dist/
COPY ./source/compute_plane/python/agent/requirements.txt /app/agent/

WORKDIR /app/agent

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app/agent
ADD ./source/compute_plane/python/agent/agent.py .



RUN pyinstaller --hidden-import=pkg_resources.py2_warn -F agent.py

RUN cp ./dist/agent ./agent


FROM python:3.7.7-slim-buster

RUN apt-get update ; apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
ADD ./examples/workloads/c++/mock_computation/mock_compute_engine.cpp .
ADD ./examples/workloads/c++/mock_computation/Makefile .
RUN make



COPY --from=0 /app/agent ./agent
CMD [ "./agent" ]
#CMD [ "python" , "./agent.py"]


