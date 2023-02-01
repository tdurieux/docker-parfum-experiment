FROM ubuntu:18.04
MAINTAINER tnek
RUN apt-get update && apt-get install --no-install-recommends -y firefox python python-pip && rm -rf /var/lib/apt/lists/*;
COPY geckodriver /usr/local/bin
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir gunicorn

COPY chal ./

EXPOSE 5000
#ENV FLAG flag{jsonppp}
#ENV CHALLENGE_CSP "default-src 'self'; script-src *.google.com; connect-src *"

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
