FROM python:latest

ENV VIRTUAL_ENV "/venv" 
RUN python -m venv $VIRTUAL_ENV
ENV PATH "$VIRTUAL_ENV/bin:$PATH"
RUN . venv/bin/activate

RUN python -m pip install --upgrade pip 

RUN apt-get update && apt-get install -y --no-install-recommends \
    poppler-utils libcairo2 libpango-1.0-0 \
    libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info ocrmypdf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /bot
COPY . /bot
RUN pip install -r requirements.txt

RUN pybabel compile -D pdf_bot -d locale

EXPOSE ${PORT}

ENV APP_URL ${APP_URL}
ENV TELE_TOKEN ${TELE_TOKEN}
ENV DEV_TELE_ID ${DEV_TELE_ID}
ENV GCP_CRED ${GCP_CRED}
ENV GCP_KEY ${GCP_KEY}
ENV SLACK_TOKEN ${SLACK_TOKEN}
ENV STRIPE_TOKEN ${STRIPE_TOKEN}

CMD ["python", "bot.py"]
