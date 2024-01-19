# RQ3

This folder contains the scripts that analyze and repair the smells from the different datasets.

## Process

1. Compute the size reduction after the repair `npx ts-node script/4.RQ3/results_analysis/1.analyze_repaired_build_repository_dockerfiles.ts`
2. Compute the statistical test about the size reduction `npx ts-node script/4.RQ3/results_analysis/2.statistical_test.ts`

## Usage

```
Options:
      --help               Show help                                   [boolean]
      --version            Show version number                         [boolean]
  -p, --resultPath [string] [default: "./data/RQ2-RQ3/build_anaysis_and_repair"]
  -c, --compression-ratio                                [number] [default: 3.2]
```