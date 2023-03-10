FROM python:3

RUN pip install --no-cache-dir grpcio
RUN pip install --no-cache-dir grpcio-tools

RUN mkdir -p /app

COPY inventory_service.py /app/

ENV PYTHONPATH /app:/app/event_store:/app/message_queue

RUN git clone https://github.com/martinez099/eventstore.git /app/event_store
RUN git clone https://github.com/martinez099/redismq.git /app/message_queue

CMD [ "python", "app/inventory_service.py" ]
