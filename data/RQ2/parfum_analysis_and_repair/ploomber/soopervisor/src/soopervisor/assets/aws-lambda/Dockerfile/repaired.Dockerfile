FROM public.ecr.aws/lambda/python:3.8

# find custom lib and included in PYTHONPATH
{%- set pypath = 'lib/' if lib else 'null' %}

{% if lib %}

ENV PYTHONPATH {{pypath}}

{% endif %}

COPY requirements.lock.txt .
RUN pip install --no-cache-dir --requirement requirements.lock.txt

COPY dist/*   .
RUN pip install --no-cache-dir *.whl --no-deps

COPY app.py   .

CMD ["app.handler"]
