FROM python:3.9.0-slim
ARG _APP_VERSION
COPY google_pso_data_validator-${_APP_VERSION}-py2.py3-none-any.whl .
RUN apt-get update \
&& apt-get install --no-install-recommends gcc -y \
&& apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir google_pso_data_validator-${_APP_VERSION}-py2.py3-none-any.whl
ENTRYPOINT ["python","-m","data_validation"]
