FROM public.ecr.aws/lambda/python:3.8

RUN yum update -y \
    && yum install -y shadow-utils.x86_64 zip unzip \
        gcc-c++ make openssl-devel zlib-devel readline-devel git && rm -rf /var/cache/yum

RUN pip install --no-cache-dir awswrangler==2.6.0
RUN pip install --no-cache-dir awslambdaric cloudpickle==1.6.0

RUN touch ${LAMBDA_TASK_ROOT}/logs.log && chmod a+rwx ${LAMBDA_TASK_ROOT}/logs.log

COPY index.py ${LAMBDA_TASK_ROOT}

CMD ["index.handler"]
