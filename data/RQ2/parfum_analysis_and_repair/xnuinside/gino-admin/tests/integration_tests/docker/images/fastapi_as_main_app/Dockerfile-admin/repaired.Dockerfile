FROM local/gino_admin_common_tests
# copy example source code
COPY examples/fastapi_as_main_app/requirements.txt /app/
COPY examples/fastapi_as_main_app/src/csv_to_upload /app/csv_to_upload
COPY examples/fastapi_as_main_app/src/admin.py examples/fastapi_as_main_app/src/models.py /app/

# install example requirements
RUN pip install --no-cache-dir -r requirements.txt

COPY tests/integration_tests/docker/wait_for.py /wait_for.py
CMD python /wait_for.py && python admin.py