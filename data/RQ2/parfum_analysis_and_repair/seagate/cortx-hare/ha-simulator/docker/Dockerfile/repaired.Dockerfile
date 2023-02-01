FROM centos:7 as build
RUN yum install -y epel-release \
                   python3 \
                   python3-pip \
                   git \
                   gcc \


                   telnet \
                   hostname \
                   python3-devel && rm -rf /var/cache/yum
WORKDIR /app
COPY ./requirements.txt /app/requirements.txt
COPY ./patches/ /app/patches/

# --system-site-packages are required to make cortx-py-utils be visible from within of the virtualenv
RUN python3 -m venv --system-site-packages .py-venv/ \
    && source ./.py-venv/bin/activate \
    && pip install --no-cache-dir -r ./requirements.txt
RUN pip3 install --no-cache-dir -r https://raw.githubusercontent.com/Seagate/cortx-utils/main/py-utils/python_requirements.txt \
    && pip3 install --no-cache-dir -r https://raw.githubusercontent.com/Seagate/cortx-utils/main/py-utils/python_requirements.ext.txt \
    && yum install -y http://cortx-storage.colo.seagate.com/releases/cortx/github/main/centos-7.9.2009/last_successful/$( curl -f --silent https://cortx-storage.colo.seagate.com/releases/cortx/github/main/centos-7.9.2009/last_successful/ | grep py-utils | sed 's/.*href="\([^"]*\)".*/\1/g') && rm -rf /var/cache/yum
RUN    git config --global user.name "Konstantin Nekrasov" \
    && git config --global user.email "konstantin.nekrasov@seagate.com" \
    && git clone --branch main https://github.com/Seagate/cortx-ha.git
WORKDIR /app/cortx-ha/
RUN find /app/patches -type f -print0 | xargs -0 -n1 git am
RUN source ../.py-venv/bin/activate && python ./setup.py install

FROM build as dev
WORKDIR /app
COPY ./run.sh /app/run.sh
CMD ["/bin/bash", "/app/run.sh"]
