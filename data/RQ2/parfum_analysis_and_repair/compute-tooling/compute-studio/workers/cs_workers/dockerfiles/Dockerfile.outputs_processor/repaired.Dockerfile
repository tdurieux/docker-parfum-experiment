ARG TAG
FROM distributed

# install packages for chromium
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
    libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
    libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
    libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
    libnss3 && rm -rf /var/lib/apt/lists/*;


RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir pyppeteer2 rq && \
    conda install -c conda-forge jinja2 bokeh && \
    pyppeteer-install

RUN mkdir /home/cs_workers
COPY workers/cs_workers /home/cs_workers
COPY workers/setup.py /home
RUN cd /home/ && pip install --no-cache-dir -e .

COPY secrets /home/secrets
RUN pip install --no-cache-dir -e ./secrets

COPY deploy /home/deploy
RUN pip install --no-cache-dir -e ./deploy

WORKDIR /home/cs_workers

ENV PYTHONUNBUFFERED 1

CMD ["uvicorn", "services.outputs_processor:app", "--host", "0.0.0.0", "--port", "5000", "--reload"]