FROM python:3.6-slim
WORKDIR /workdir
COPY out/*.whl /workdir
ENV KMP_AFFINITY=granularity=fine,compact,1,0 KMP_BLOCKTIME=1 KMP_SETTINGS=0
ENV TF_XLA_FLAGS="--tf_xla_auto_jit=1 --tf_xla_cpu_global_jit"
ADD tf-test.py /root/
RUN pip install --no-cache-dir *.whl
ENTRYPOINT "/root/tf-test.py"
