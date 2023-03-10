FROM public.ecr.aws/lambda/python:3.8

COPY --from=frontend-awslambda /app/build ${LAMBDA_TASK_ROOT}/frontend/public

COPY requirements.txt  .
RUN pip3 install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}" && \
     pip3 install --no-cache-dir aws-lambda-powertools

COPY app.py ${LAMBDA_TASK_ROOT}
COPY api ${LAMBDA_TASK_ROOT}/api
COPY awslambda ${LAMBDA_TASK_ROOT}/awslambda

CMD ["awslambda.entrypoint.lambda_handler"]
