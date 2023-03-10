FROM python:3.6-slim

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="symptomsurvey_backed/TWITTER"
LABEL org.label-schema.description="Social Media Scraper for public health issues in Clakamas County Oregon"
LABEL org.label-schema.url="http://www.codeforpdx.org/projects/2"
LABEL org.label-schema.vcs-url="https://github.com/codeforpdx/symptomsurvey_backend"

WORKDIR /usr/src/app

# TODO: Add EXPOSE instruction to specify port that will be exposed

#do this BEFORE copying the rest, that way only changes to requirements.txt will cause pip to execute
COPY ./TWITTER/requirements.txt ./TWITTER/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r ./TWITTER/requirements.txt

COPY ./TWITTER/. ./TWITTER
COPY ./SHARED/. ./SHARED

WORKDIR /usr/src/app/TWITTER
# Start Website back-end
CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"]
