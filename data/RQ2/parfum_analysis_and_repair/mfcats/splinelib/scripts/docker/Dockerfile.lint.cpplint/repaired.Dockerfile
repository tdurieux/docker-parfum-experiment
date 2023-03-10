FROM christophsusen/spack

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

# execute cpplint
CMD cpplint --extensions=cc,h --recursive /code/src/* /code/test/*