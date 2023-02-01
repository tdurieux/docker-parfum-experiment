FROM python:3.7.5

ENV PYTHONUNBUFFERED 1
ADD ./agent /
ADD ./utils /
ADD requirements/agent.txt /
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r agent.txt
CMD [ "python", "agent.py" ]
