FROM python:3.6
RUN mkdir /gitsec
WORKDIR /gitsec
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY master.cfg buildbot.tac ./
COPY templates ./templates
CMD ["buildbot", "start", "--nodaemon"]
