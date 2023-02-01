FROM giovtorres/docker-centos7-slurm:latest
RUN yum install -y glibc clang cargo && rm -rf /var/cache/yum
RUN echo "JobSubmitPlugins=job_submit/slurm_banking" >> /etc/slurm/slurm.conf \
    && echo "JobCompPlugins=jobcomp/slurm_banking" >> /etc/slurm/slurm.conf
ADD . /slurm-banking-plugins
RUN cd /slurm-banking-plugins \
    && git submodule update --init --recursive \
    && pushd slurm \
    && git checkout slurm-18-08-7-1 \
    && popd \
    && make all \
    && make install \
    && cp prices.toml /etc/slurm/.
