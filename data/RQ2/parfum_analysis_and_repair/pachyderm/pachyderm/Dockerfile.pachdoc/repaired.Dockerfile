FROM python:3.7 as mkdocs
RUN apt-get clean && apt-get update

WORKDIR /usr/src/app/doc
COPY doc/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install --no-install-recommends -y mkdocs && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/app/
RUN ./build.sh


FROM mkdocs as netlify

RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install netlify-cli -g && npm cache clean --force;
RUN npm install netlify-plugin-checklinks && npm cache clean --force;



