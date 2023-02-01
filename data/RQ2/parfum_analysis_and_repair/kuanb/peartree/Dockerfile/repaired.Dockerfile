FROM kuanb/peartree

RUN mkdir /code && \
	pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir numpy==1.18.4 scipy==1.4.1

WORKDIR /code

COPY requirements_dev.txt /code/
RUN pip install --no-cache-dir -r requirements_dev.txt

COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt