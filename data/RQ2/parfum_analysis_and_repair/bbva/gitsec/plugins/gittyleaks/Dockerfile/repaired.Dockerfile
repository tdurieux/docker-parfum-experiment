FROM python:3.6
RUN pip install --no-cache-dir gittyleaks

COPY --from=bbvalabsci/buildbot-washer-worker:latest /washer /washer
COPY tasks.py /washer/
ENTRYPOINT ["/washer/entrypoint.sh"]
CMD ["/washer/tasks.py"]
