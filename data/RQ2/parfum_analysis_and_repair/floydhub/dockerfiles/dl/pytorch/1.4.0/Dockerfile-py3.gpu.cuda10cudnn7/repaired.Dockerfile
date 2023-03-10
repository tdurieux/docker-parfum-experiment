FROM floydhub/tensorflow:2.1-gpu.cuda10cudnn7-py3_aws.54
MAINTAINER Floyd Labs "support@floydhub.com"

RUN pip --no-cache-dir install --upgrade \
        http://download.pytorch.org/whl/cu100/torch-1.4.0%2Bcu100-cp36-cp36m-linux_x86_64.whl \
        http://download.pytorch.org/whl/cu100/torchvision-0.5.0%2bcu100-cp36-cp36m-linux_x86_64.whl \
        torchtext==0.5.0 \
        tensorboardX==2.0 \
        fastai \
        transformers \
	tokenizers \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache

# Fix Jupyterlab - see https://github.com/jupyter/jupyter/issues/401
# TODO: move this on dl-base
RUN pip --no-cache-dir install --upgrade notebook \
    && rm -rf /pip_pkg \
    && rm -rf /tmp/* \
    && rm -rf /root/.cache