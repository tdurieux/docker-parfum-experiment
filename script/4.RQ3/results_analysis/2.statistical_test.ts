const tTest = require("ttest");
import { mean, standardDeviation } from "simple-statistics";

import { readFile, readdir } from "fs/promises";
import { join } from "path";
import Yargs from "yargs/yargs";
import config from "../../../config";
import { RepositoryAnalysisResult } from "../../3.RQ2/repair_repository_dockerfile";
import { SIZE_RULES, smellName } from "../../utils";

const ALPHA = 0.05;
// Function to calculate the paired t-test
function pairedTTest(before: number[], after: number[]) {
  // Make sure both arrays have the same length
  if (before.length !== after.length) {
    throw new Error(
      'The "before" and "after" arrays must have the same length.'
    );
  }

  // Perform the paired t-test
  const ttest = new tTest(before, after, { mu: 0, alpha: ALPHA });

  // Return the results
  return {
    meanBefore: mean(before),
    meanAfter: mean(after),
    devisionBefore: standardDeviation(before),
    devisionAfter: standardDeviation(after),
    confidence: ttest.confidence(),
    tValue: ttest.testValue(),
    freedom: ttest.freedom(),
    pValue: ttest.pValue(),
    valid: ttest.valid(),
    cohenEffectSize: cohenEffectSize(before, after),
    pearsonCorrelation: pearsonCorrelation(before, after),
    calculatePearsonCorrelation: calculatePearsonCorrelation(before, after),
    pearsonCorrelation2: pearsonCorrelation2(
      { before, after },
      "before",
      "after"
    ),
  };
}
function calculatePearsonCorrelation(x: number[], y: number[]): number {
  if (x.length !== y.length) {
    throw new Error("Arrays must have the same length");
  }

  const n = x.length;
  let sumX = 0;
  let sumY = 0;
  let sumXY = 0;
  let sumX2 = 0;
  let sumY2 = 0;

  for (let i = 0; i < n; i++) {
    sumX += x[i];
    sumY += y[i];
    sumXY += x[i] * y[i];
    sumX2 += x[i] * x[i];
    sumY2 += y[i] * y[i];
  }

  const numerator = n * sumXY - sumX * sumY;
  const denominator = Math.sqrt(
    (n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY)
  );

  if (denominator === 0) {
    throw new Error("Denominator is zero, correlation cannot be calculated");
  }

  const correlation = numerator / denominator;
  return correlation;
}

function pearsonCorrelation(variable1: number[], variable2: number[]): number {
  if (variable1.length !== variable2.length) {
    throw new Error("Both variables must have the same length.");
  }

  const n = variable1.length;
  const sumX = variable1.reduce((acc, val) => acc + val, 0);
  const sumY = variable2.reduce((acc, val) => acc + val, 0);
  const sumXY = variable1.reduce(
    (acc, val, index) => acc + val * variable2[index],
    0
  );
  const sumX2 = variable1.reduce((acc, val) => acc + val ** 2, 0);
  const sumY2 = variable2.reduce((acc, val) => acc + val ** 2, 0);

  const numerator = n * sumXY - sumX * sumY;
  const denominator = Math.sqrt(
    (n * sumX2 - sumX ** 2) * (n * sumY2 - sumY ** 2)
  );

  return numerator / denominator;
}

/**
 *  Calculate the person correlation score between two items in a dataset.
 *
 *  @param  {object}  prefs The dataset containing data about both items that
 *                    are being compared.
 *  @param  {string}  p1 Item one for comparison.
 *  @param  {string}  p2 Item two for comparison.
 *  @return {float}  The pearson correlation score.
 */
function pearsonCorrelation2(prefs, p1, p2) {
  var si = [];

  for (var key in prefs[p1]) {
    if (prefs[p2][key]) si.push(key);
  }

  var n = si.length;

  if (n == 0) return 0;

  var sum1 = 0;
  for (var i = 0; i < si.length; i++) sum1 += prefs[p1][si[i]];

  var sum2 = 0;
  for (var i = 0; i < si.length; i++) sum2 += prefs[p2][si[i]];

  var sum1Sq = 0;
  for (var i = 0; i < si.length; i++) {
    sum1Sq += Math.pow(prefs[p1][si[i]], 2);
  }

  var sum2Sq = 0;
  for (var i = 0; i < si.length; i++) {
    sum2Sq += Math.pow(prefs[p2][si[i]], 2);
  }

  var pSum = 0;
  for (var i = 0; i < si.length; i++) {
    pSum += prefs[p1][si[i]] * prefs[p2][si[i]];
  }

  var num = pSum - (sum1 * sum2) / n;
  var den = Math.sqrt(
    (sum1Sq - Math.pow(sum1, 2) / n) * (sum2Sq - Math.pow(sum2, 2) / n)
  );

  if (den == 0) return 0;

  return num / den;
}

function cohenEffectSize(group1: number[], group2: number[]): number {
  const meanDiff = mean(group1) - mean(group2);
  const pooledStdDev = Math.sqrt(
    (standardDeviation(group1) ** 2 + standardDeviation(group2) ** 2) / 2
  );
  return meanDiff / pooledStdDev;
}

(async () => {
  const argv = await Yargs(process.argv.slice(2))
    .option("resultPath", {
      type: "string",
      demandOption: false,
      alias: "p",
      default: config.defaultBuildDockerfileOutputPath,
    })
    .parse();

  const SMELL_NAMES = SIZE_RULES.map((r) => r.name);

  const beforeRepair: number[] = [];
  const afterRepair: number[] = [];
  const beforeRepairPerSmell: { [key: string]: number[] } = {};
  const afterRepairPerSmell: { [key: string]: number[] } = {};

  let nbDockerfiles = 0;
  const owners = await readdir(argv.resultPath);
  for (const owner of owners) {
    const repos = await readdir(join(argv.resultPath, owner));
    for (const repoFile of repos) {
      try {
        const results = JSON.parse(
          await readFile(join(argv.resultPath, owner, repoFile), "utf-8")
        ) as RepositoryAnalysisResult;
        if (
          !results.repair ||
          !results.repairedBuild ||
          results.repair.violations.length === 0 ||
          results.repairedBuild.error
        ) {
          continue;
        }
        const smellNames = new Set<string>(
          results.repair.violations
            .map((v) => smellName(v.name))
            .filter((v) => SMELL_NAMES.includes(v))
        );
        if (smellNames.size === 0) continue;

        nbDockerfiles++;

        const originalBuild = results.originalBuild;
        const repairedBuild = results.repairedBuild;

        beforeRepair.push(originalBuild.imageSize);
        afterRepair.push(repairedBuild.imageSize);

        smellNames.forEach((smellName) => {
          if (!beforeRepairPerSmell[smellName]) {
            beforeRepairPerSmell[smellName] = [];
            afterRepairPerSmell[smellName] = [];
          }
          beforeRepairPerSmell[smellName].push(originalBuild.imageSize);
          afterRepairPerSmell[smellName].push(repairedBuild.imageSize);
        });
      } catch (error) {
        console.error(`Error while processing ${owner}/${repoFile}`);
        // await rm(join(resultPath, owner, repoFile));
      }
    }
  }
  // Call the pairedTTest function with your data

  console.log(afterRepair.join(","));
  // const results = pairedTTest(beforeRepair, afterRepair);
  // console.log(results);

  // for (const smellName in beforeRepairPerSmell) {
  //   const results = pairedTTest(
  //     beforeRepairPerSmell[smellName],
  //     afterRepairPerSmell[smellName]
  //   );
  //   console.log(smellName, results);
  // }

  // console.log(`nbDockerfiles: ${nbDockerfiles}`)
})();
