FROM floydhub/dl-base:3.0.0-gpu-py3.22
MAINTAINER Floyd Labs "support@floydhub.com"

RUN pip --no-cache-dir install --upgrade http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp36-cp36m-linux_x86_64.whl \
    torchvision==0.2.0



RUN pip --no-cache-dir install --upgrade tensorboardX==1.0