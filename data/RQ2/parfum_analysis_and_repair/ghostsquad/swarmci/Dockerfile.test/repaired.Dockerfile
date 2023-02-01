FROM swarmci
RUN pip install --no-cache-dir tox
CMD [ "python", "runtox.py", "-e", "linting,py35" ]