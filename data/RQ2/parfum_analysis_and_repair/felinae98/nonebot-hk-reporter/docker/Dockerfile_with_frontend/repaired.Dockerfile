FROM python:3.9
RUN python3 -m pip install poetry && poetry config virtualenvs.create false
WORKDIR /app
RUN apt-get update && apt-get install --no-install-recommends -y xvfb fonts-noto-color-emoji ttf-unifont \
    libfontconfig1 libfreetype6 xfonts-cyrillic xfonts-scalable fonts-liberation \
    fonts-ipafont-gothic fonts-wqy-zenhei fonts-tlwg-loma-otf \
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcairo2 libcups2 libdbus-1-3 libdrm2 libegl1 libgbm1 libglib2.0-0 libgtk-3-0 \
    libnspr4 libnss3 libpango-1.0-0 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
    libxdamage1 libxext6 libxfixes3 libxrandr2 libxshmfence1 \
    && rm -rf /var/lib/apt/lists/*
COPY ./pyproject.toml ./poetry.lock* /app/
RUN poetry install --no-dev --no-root
RUN playwright install chromium
ADD src /app/src
ADD bot.py /app/
ENV HOST=0.0.0.0
CMD ["python", "bot.py"]

# vim: ft=dockerfile
