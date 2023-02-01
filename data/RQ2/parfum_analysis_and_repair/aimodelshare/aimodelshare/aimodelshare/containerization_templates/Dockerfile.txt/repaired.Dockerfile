FROM public.ecr.aws/lambda/python:$python_version

COPY lambda_function.py ./
COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt

CMD ["lambda_function.lambda_handler"]