FROM python:2.7-alpine

COPY setup.py tweepub.py /tweepub/
RUN pip install --no-cache-dir /tweepub

ENTRYPOINT ["tweepub"]
