FROM lambci/lambda:build-python3.7

COPY aws-cfn-ses-domain ./

RUN zip -X -r lambda.zip ./aws_cfn_ses_domain/ index.py

CMD mkdir -p /output/ && mv lambda.zip /output/