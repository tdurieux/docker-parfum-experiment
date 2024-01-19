# RQ4

This folder contains the scripts that analyze and repair the smells from the different datasets.

## Process

1. Indetify the potential repository to open PR `npx ts-node script/5.RQ4/1.filter_repositories_for_pr.ts`
2. Utility for generate the description of a PR `npx ts-node script/5.RQ4/createPullRequest.ts`
3. Analyze the open PRs and generate the template for the README and for the paper `npx ts-node script/5.RQ4/results_analysis/1.analyze_merged_prs.ts`