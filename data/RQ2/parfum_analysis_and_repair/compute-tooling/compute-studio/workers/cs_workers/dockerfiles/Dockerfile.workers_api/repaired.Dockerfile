ARG TAG
FROM distributed

ENV HOST 0.0.0.0
ENV PORT 8888
ENV DEBUG false

ENV IS_SCHEDULER True

# expose the app port
EXPOSE 80
EXPOSE 8888

RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir python-multipart sqlalchemy python-jose[cryptography] psycopg2-binary passlib[bcrypt]

RUN mkdir /home/cs_workers
COPY workers/cs_workers /home/cs_workers
COPY workers/setup.py /home
RUN cd /home/ && pip install --no-cache-dir -e .

COPY secrets /home/secrets
RUN pip install --no-cache-dir -e ./secrets

COPY deploy /home/deploy
RUN pip install --no-cache-dir -e ./deploy

WORKDIR /home

ENV PYTHONUNBUFFERED 1

WORKDIR /home/cs_workers/services/

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "5000", "--reload"]