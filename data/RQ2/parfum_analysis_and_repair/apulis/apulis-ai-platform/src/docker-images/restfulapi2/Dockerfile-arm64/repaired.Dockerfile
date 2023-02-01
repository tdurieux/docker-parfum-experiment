FROM apulistech/backendbase:1.9-arm64
MAINTAINER Jin Li <jin.li@apulis.com>

# kubectl will be mapped by service
RUN rm /etc/apache2/mods-enabled/mpm_*
COPY mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/ports.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf
RUN ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load

COPY dlws-restfulapi.wsgi /wsgi/dlws-restfulapi.wsgi

COPY runScheduler.sh /
RUN chmod +x /runScheduler.sh
COPY pullsrc.sh /
RUN chmod +x /pullsrc.sh
COPY run.sh /
RUN chmod +x /run.sh

COPY ClusterManager/requirements.txt /
# TODO refine later
# install requirements
RUN rm -rf /usr/lib/python2.7/dist-packages/yaml
RUN rm -rf /usr/lib/python2.7/dist-packages/PyYAML-*
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
RUN pip config set install.trusted-host mirrors.aliyun.com
RUN pip install --no-cache-dir -r /requirements.txt
RUN apt update && apt install --no-install-recommends -y libjpeg-dev pkg-config libpng-dev libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir wheel
RUN pip install --no-cache-dir MySQL-python DBUtils==1.3 Pillow futures six numpy matplotlib pycocotools dnspython

ADD Jobs_Templete /DLWorkspace/src/Jobs_Templete
ADD utils /DLWorkspace/src/utils
ADD RestAPI /DLWorkspace/src/RestAPI
ADD ClusterManager /DLWorkspace/src/ClusterManager

CMD /run.sh
