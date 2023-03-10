# Dockerfile for interuss/monitoring
#
# The image generated by this Dockerfile (via ./build.sh) includes the entire
# `monitoring` folder contents in /app/monitoring and has installed dependencies
# necessary to run any of the monitoring tools.  See documentation for any of
# the applicable tools for instructions on how to use the generated image.  A
# search for "interuss/monitoring" within the repository should yield most of
# the places where this image is in use.

FROM python:3.8
# Not -alpine because: https://stackoverflow.com/a/58028091/651139

RUN apt-get update && apt-get install -y --no-install-recommends openssl && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /app/monitoring/monitorlib
COPY monitorlib/requirements.txt /app/monitoring/monitorlib/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/monitorlib/requirements.txt

RUN mkdir -p /app/monitoring/interoperability
COPY interoperability/requirements.txt /app/monitoring/interoperability/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/interoperability/requirements.txt

RUN mkdir -p /app/monitoring/loadtest
COPY loadtest/requirements.txt /app/monitoring/loadtest/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/loadtest/requirements.txt

RUN mkdir -p /app/monitoring/mock_uss
COPY mock_uss/requirements.txt /app/monitoring/mock_uss/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/mock_uss/requirements.txt

RUN mkdir -p /app/monitoring/prober
COPY prober/requirements.txt /app/monitoring/prober/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/prober/requirements.txt

RUN mkdir -p /app/monitoring/tracer
COPY tracer/requirements.txt /app/monitoring/tracer/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/tracer/requirements.txt

RUN mkdir -p /app/monitoring/uss_qualifier
COPY uss_qualifier/requirements.txt /app/monitoring/uss_qualifier/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/uss_qualifier/requirements.txt

RUN mkdir -p /app/monitoring/uss_qualifier/webapp
COPY uss_qualifier/webapp/requirements.txt /app/monitoring/uss_qualifier/webapp/requirements.txt
RUN pip install --no-cache-dir -r /app/monitoring/uss_qualifier/webapp/requirements.txt

RUN rm -rf __pycache__

ADD . /app/monitoring
COPY health_check.sh /app/health_check.sh
WORKDIR /app/monitoring

# Additional preparations for uss_qualifier
RUN mkdir -p /app/kml-input
RUN mkdir -p /app/flight-states

# Additional preparations for uss_qualifier/webapp
RUN mkdir -p /app/uss-host-files

HEALTHCHECK CMD sh /app/health_check.sh

ENV PYTHONPATH /app
ARG version
ENV MONITORING_VERSION=$version
ENTRYPOINT []
