FROM open-path-warehouse:latest--base

LABEL "role"=jobs

# Start the main process.
CMD ["rake", "jobs:work"]