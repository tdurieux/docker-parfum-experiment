FROM open-path-cas:latest--base

LABEL "role"=jobs

# Start the main process.
CMD ["rake", "jobs:work"]