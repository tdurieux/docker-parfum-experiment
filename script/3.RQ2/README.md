# RQ2

This folder contains the scripts that repair the smells and build the Docker image

## Process

1. Analyze and smell repair the binnacle dataset `npx ts-node script/2.RQ2/1.repair_build_repository_dockerfiles.ts`
2. Analyze build errors `npx ts-node script/2.RQ2/results_analysis/analyze_build_error.ts`
3. Analyze repaired build errors `npx ts-node script/2.RQ2/results_analysis/analyze_build_repair_errors.ts`
4. Analyze repaired build errors `npx ts-node script/2.RQ2/results_analysis/analyze_repaired_dockerfiles.ts`

## Usage 1.repair_build_repository_dockerfiles.ts

```
Options:
      --help                Show help                                  [boolean]
      --version             Show version number                        [boolean]
  -p, --parallel                                          [number] [default: 10]
  -l, --repositoryListPath                                              [string]
      --skipExisting                                   [boolean] [default: true]
      --outputPath [string] [default: "./data/RQ2-RQ3/build_anaysis_and_repair"]
      --resultPath    [string] [default:"./data/RQ1/parfum_analysis_and_repair"]
      --workdir                       [string] [default: "/tmp/dinghy-analysis"]
```