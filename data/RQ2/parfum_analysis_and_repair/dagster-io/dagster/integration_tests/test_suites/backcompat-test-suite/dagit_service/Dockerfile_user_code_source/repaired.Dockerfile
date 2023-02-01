FROM python:3.8-slim

COPY ./python_modules/ /tmp/python_modules/

WORKDIR /tmp

RUN pip install --no-cache-dir \
    -e python_modules/dagster \
    -e python_modules/librari \
    -e python_modules/librari

# Ensure all dagster installs were local
RUN ! (pip list --exclude-editable | grep -e dagster -e dagit)

WORKDIR /opt/dagster/app

COPY repo.py /opt/dagster/app

# Run dagster gRPC server on port 8090

EXPOSE 8090

# CMD allows this to be overridden from run launchers or executors that want
# to run other commands against your repository
CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "8090", "-f", "repo.py"]