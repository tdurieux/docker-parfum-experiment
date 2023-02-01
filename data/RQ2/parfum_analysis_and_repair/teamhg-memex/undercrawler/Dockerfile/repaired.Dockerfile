FROM arachnado

WORKDIR /undercrawler

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    formasaurus init
COPY . .
RUN pip install --no-cache-dir -e .
