from python:3
run pip install --no-cache-dir flask gunicorn
copy . .
entrypoint gunicorn -w 4 -b 0.0.0.0:8000 webmic:app
