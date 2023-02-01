FROM apulistech/backendbase:1.9
MAINTAINER Jin Li <jin.li@apulis.com>

ADD ./sources.list /etc/apt
RUN apt-get update && apt-get install -y libglib2.0-0 libsm6 libxext6 libxrender-dev

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
RUN pip install -r /requirements.txt
RUN pip install MySQL-python DBUtils==1.3 Pillow futures six numpy matplotlib pycocotools dnspython opencv-python==4.2.0.32

RUN apt-get install libpq-dev -y
RUN pip install psycopg2

ADD Jobs_Templete /DLWorkspace/src/Jobs_Templete
ADD utils /DLWorkspace/src/utils
ADD RestAPI /DLWorkspace/src/RestAPI
ADD ClusterManager /DLWorkspace/src/ClusterManager

# add version info
ADD version-info /
RUN pip install --ignore-installed mysql-connector-python

CMD /run.sh
