FROM centos
RUN yum list | grep python \
    && yum -y install python38 \ 
    && yum -y install git \ 
    && cd / &&  git clone https://github.com/jyolo/wLogger \ 
    && cd /wLogger \
    && pip3 install --no-cache-dir -r requirements.txt \
    && echo "/usr/bin/python3 /wLogger/main.py \$@" > run.sh && rm -rf /var/cache/yum




ENTRYPOINT ["/bin/bash","/wLogger/run.sh"]
