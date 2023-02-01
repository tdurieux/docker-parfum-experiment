FROM public.ecr.aws/lambda/python:3.9

COPY *.py ${LAMBDA_TASK_ROOT}/
RUN ls
COPY model-last/ ${LAMBDA_TASK_ROOT}/model-last/
COPY pyproject.toml ${LAMBDA_TASK_ROOT}/
COPY poetry.lock ${LAMBDA_TASK_ROOT}/
RUN pip install --no-cache-dir poetry
RUN poetry export --without-hashes -f requirements.txt --output requirements.txt
RUN yum update && \
  yum install -y \
  g++ \
  make \
  cmake \
  unzip \
  libcurl4-openssl-dev\
  gcc \
  libjpeg-devel \
  gcc-c++ && rm -rf /var/cache/yum
RUN python3.9 -m pip install -r requirements.txt -t ${LAMBDA_TASK_ROOT}/
RUN python3.9 -m pip install awslambdaric --target ${LAMBDA_TASK_ROOT}/
RUN yum install -y mesa-libGL && rm -rf /var/cache/yum
RUN yum install -y ImageMagick ImageMagick-devel ImageMagick-perl && rm -rf /var/cache/yum

# Command can be overwritten by providing a different command in the template directly.
CMD ["lambda_function.handler"]