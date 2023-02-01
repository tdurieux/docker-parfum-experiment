FROM python:3.9
ADD requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt
ADD src /usr/local/src
RUN pip install --no-cache-dir /usr/local/src
ENTRYPOINT [ "python", "-m", "gtfs_rt_archive" ]
