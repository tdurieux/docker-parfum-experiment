FROM uhub.service.ucloud.cn/uaishare/gpu_uaitrain_ubuntu-16.04_python-2.7.6_tensorflow-1.5.0:v1.0

RUN apt-get update && apt-get install --no-install-recommends -y python-opencv python-tk && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir shapely -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com

ADD ./EAST/ /data/