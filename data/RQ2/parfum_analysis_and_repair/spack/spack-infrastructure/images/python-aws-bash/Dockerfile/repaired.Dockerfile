FROM python:3

# bug in spack s3 handling requires older botocore:
#     https://github.com/spack/spack/issues/28830
RUN pip install --no-cache-dir --upgrade \
    awscli==1.22.46 \
    boto3==1.20.35 \
    botocore==1.23.46

ENTRYPOINT ["/bin/bash"]
