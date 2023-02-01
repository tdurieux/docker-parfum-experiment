FROM python:3.7-slim
ARG BRANCH_NAME_KF=master

RUN apt-get update \
  && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

COPY . .
RUN pip install --no-cache-dir --upgrade pip
RUN git clone -b ${BRANCH_NAME_KF} https://github.com/kserve/kserve
RUN pip install --no-cache-dir -e ./kserve/python/kserve
ENTRYPOINT ["python", "-m", "image_transformer"]
