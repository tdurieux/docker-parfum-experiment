FROM python:3.5.3-slim

WORKDIR /app

ADD agent/* /app/

RUN pip install --no-cache-dir -r requirements.txt

ENV NAME Learner

CMD ["python", "example_learner.py"]

