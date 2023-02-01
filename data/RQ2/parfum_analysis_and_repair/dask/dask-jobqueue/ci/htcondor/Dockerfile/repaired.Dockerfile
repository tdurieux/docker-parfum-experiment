FROM  htcondor/submit:el7 as submit

RUN yum install -y gcc git && rm -rf /var/cache/yum
RUN yum install -y python3-devel python3-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir dask distributed pytest

FROM  htcondor/execute:el7 as execute
RUN yum install -y python3 && rm -rf /var/cache/yum
COPY --from=submit /usr/local/lib/python3.6 /usr/local/lib/python3.6
COPY --from=submit /usr/local/lib64/python3.6 /usr/local/lib64/python3.6
