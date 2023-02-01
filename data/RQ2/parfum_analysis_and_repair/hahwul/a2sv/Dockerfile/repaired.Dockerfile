FROM python:2-alpine

ADD * ./

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python","a2sv.py"]

# Build
# docker build -t a2sv .
# Run
# docker run a2sv -t example.com
