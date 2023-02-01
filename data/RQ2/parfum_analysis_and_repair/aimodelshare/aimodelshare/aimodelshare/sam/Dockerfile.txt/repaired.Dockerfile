FROM public.ecr.aws/lambda/python:$python_version

COPY $directory/. ./
COPY $requirements_file_path ./

RUN pip install --no-cache-dir -r ./requirements.txt

CMD ["lambda_function.lambda_handler"]