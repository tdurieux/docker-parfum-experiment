FROM python:3-alpine

ADD jira-dependency-graph.py /jira/
ADD requirements.txt /jira/
WORKDIR /jira
RUN pip install --no-cache-dir -r requirements.txt
