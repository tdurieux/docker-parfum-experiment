FROM python:latest

RUN pip install pika

ENV AMQPURL amqp://cb:cb@rabbitmq:5672

COPY ./ /

ENTRYPOINT ["/bin/bash"]
CMD ["-c","sleep 60 && python stress_rabbit.py"]