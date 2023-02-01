FROM python:3.7.5-slim-stretch

RUN mkdir -p /tmp/results

WORKDIR /tmp/

# In a typical production deploy, use the following pattern.

# ADD requirements.txt .

# RUN pip install -r requirements.txt

# ADD dagster dagster
# ADD dagit dagit

ADD . .

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -e dagster && pip install --no-cache-dir dagit && pip install --no-cache-dir dagster-pandas && pip install --no-cache-dir dagstermill && pip install --no-cache-dir pytest

# ENTRYPOINT [ "dagit" ]
#
# EXPOSE 3000
