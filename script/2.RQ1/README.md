# RQ1

This folder contains the scripts that analyze and repair the smells from the different datasets.

## Process

1. Analyze and smell repair the binnacle dataset `npx ts-node script/2.RQ1/1.analyze_repair_binnacle_dataset.ts`
2. Analyze and smell repair the Parfum dataset `npx ts-node script/2.RQ1/2.analyze_repair_new_dataset.ts`
3. Compare Binnacle to Parfum results `npx ts-node script/2.RQ1/results_analysis/1.compare_binnacle_parfum.ts`
4. Extract precision and recall from groundturth dataset `npx ts-node script/2.RQ1/results_analysis/2.analyze_groundtruth.ts`
5. Extract results per run from the groundturth dataset `npx ts-node script/2.RQ1/results_analysis/3.analyze_groundtruth_per_rule.ts`
