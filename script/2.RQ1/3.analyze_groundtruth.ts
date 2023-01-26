import { basename, join } from "path";
import config from "../../config";
import { readAnalsysiResults, smellName, walk } from "../utils";
import { readFile } from "fs/promises";
import { RULES } from "@tdurieux/docker-parfum";
import { Position } from "@tdurieux/dinghy/build/docker-type";

async function main() {
  const precisions = [];
  const recalls = [];
  const f1s = [];

  const binnaclePrecisions = [];
  const binnacleRecalls = [];
  const binnacleF1s = [];

  const binnacleResultPath = join(
    config.dataFolder,
    "reproduction/results-github-individual.txt"
  );
  const binnacleResults = (await readFile(binnacleResultPath, "utf-8"))
    .split("\n")
    .slice(1)
    .map((line) => {
      try {
        const o = JSON.parse(line);
        const output: {
          file: string;
          all_violations: { [key: string]: number };
        } = {
          file: o.file_sha,
          all_violations: {},
        };
        for (const smell in o.all_violations) {
          if (o.all_violations[smell].violations === 0) continue;
          output.all_violations[smellName(smell)] =
            o.all_violations[smell].violations;
        }
        return output;
      } catch (error) {}
    })
    .filter((f) => f);

  let missingAnalysis = 0;
  await walk(config.groundTrusts, async (path) => {
    // if (!path.endsWith("fca7c360b3659e3a00471ee952fdcd6b00785667.json")) return;
    const groundTrust: { [key: string]: Partial<Position>[] } = JSON.parse(
      await readFile(path, "utf-8")
    );
    const nbSmells = Object.keys(groundTrust).reduce(
      (acc, key) => groundTrust[key].length + acc,
      0
    );

    const binnacleResult = binnacleResults.find(
      (r) => r.file === basename(path).replace(".json", "")
    );
    const binnacleTruePositive = [];
    const binnacleFalsePositive = [];
    const binnacleFalseNegative = [];
    for (const smell in groundTrust) {
      const expected = groundTrust[smell].length;
      const actual = binnacleResult.all_violations[smell] || 0;
      if (actual === expected) {
        binnacleTruePositive.push(...new Array(expected).fill(smell));
      } else if (actual > expected) {
        binnacleTruePositive.push(...new Array(expected).fill(smell));
        binnacleFalsePositive.push([
          ...new Array(actual - expected).fill(smell),
        ]);
      } else {
        binnacleTruePositive.push(...new Array(actual).fill(smell));
        binnacleFalseNegative.push(...new Array(expected - actual).fill(smell));
      }
    }
    for (const smell in binnacleResult.all_violations) {
      if (!groundTrust[smell]) {
        binnacleFalsePositive.push(
          ...new Array(binnacleResult.all_violations[smell]).fill(smell)
        );
      }
    }

    const truePositive = [];
    const falsePositive = [];
    const falseNegative = [];
    let isMissing = false;

    const parfumResultPath = join(
      config.defaultBinnacleAnalysisAndRepairPath,
      basename(path)
    );
    try {
      const parfumResult = await readAnalsysiResults(parfumResultPath);
      // compare results to ground truth
      for (const smell in groundTrust) {
        for (const position of groundTrust[smell]) {
          const parfumPosition = parfumResult.originalSmells.find(
            (p) =>
              p.rule === smell && p.position.lineStart === position.lineStart
          );
          if (parfumPosition) {
            truePositive.push(smell);
          } else {
            falseNegative.push(smell);
          }
        }
      }
      for (const smell of parfumResult.originalSmells) {
        if (!groundTrust[smell.rule]) {
          falsePositive.push({
            rule: smell.rule,
            position: smell.position,
          });
          continue;
        }
        const find = groundTrust[smell.rule].find(
          (position) => smell.position.lineStart === position.lineStart
        );
        if (!find) {
          falsePositive.push({
            rule: smell.rule,
            position: smell.position,
          });
        }
      }
    } catch (error) {
      console.log(error);
      missingAnalysis++;
      isMissing = true;
    }

    const precision = isMissing
      ? 0
      : nbSmells == 0
      ? falsePositive.length == 0
        ? 1
        : 0
      : truePositive.length / (truePositive.length + falsePositive.length) || 0;
    const recall = isMissing
      ? 0
      : nbSmells == 0
      ? falseNegative.length == 0
        ? 1
        : 0
      : truePositive.length / (truePositive.length + falseNegative.length);
    const f1 = (2 * (precision * recall)) / (precision + recall) || 0;

    precisions.push(precision);
    recalls.push(recall);
    f1s.push(f1);

    console.log(
      `${basename(path)}: ${truePositive.length} true positive, ${
        falsePositive.length
      } false positive, ${
        falseNegative.length
      } false negative, ${precision} precision, ${recall} recall, ${f1} f1, ${missingAnalysis} missing analysis`
    );

    const binnaclePrecision =
      nbSmells == 0
        ? binnacleFalsePositive.length == 0
          ? 1
          : 0
        : binnacleTruePositive.length /
            (binnacleTruePositive.length + binnacleFalsePositive.length) || 0;
    const binnacleRecall =
      nbSmells == 0
        ? binnacleFalseNegative.length == 0
          ? 1
          : 0
        : binnacleTruePositive.length /
          (binnacleTruePositive.length + binnacleFalseNegative.length);
    const binnacleF1 =
      (2 * (binnaclePrecision * binnacleRecall)) /
        (binnaclePrecision + binnacleRecall) || 0;

    binnaclePrecisions.push(binnaclePrecision);
    binnacleRecalls.push(binnacleRecall);
    binnacleF1s.push(binnacleF1);
    console.log(
      `${basename(path)}: ${binnacleTruePositive.length} true positive, ${
        binnacleFalsePositive.length
      } false positive, ${
        binnacleFalseNegative.length
      } false negative, ${binnaclePrecision} precision, ${binnacleRecall} recall, ${binnacleF1} f1`
    );
  });

  function avergage(arr: number[]) {
    return arr.reduce((acc, p) => acc + p, 0) / arr.length;
  }
  function median(arr: number[]) {
    const sorted = arr.sort((a, b) => a - b);
    const middle = Math.floor(sorted.length / 2);
    if (sorted.length % 2 === 0) {
      return (sorted[middle - 1] + sorted[middle]) / 2;
    }
    return sorted[middle];
  }
  console.log(`\\def\\avgPrecision{${avergage(precisions)}}`);
  console.log(`\\def\\medPrecision{${median(precisions)}}`);

  console.log(`\\def\\avgRecall{${avergage(recalls)}}`);
  console.log(`\\def\\medRecall{${median(recalls)}}`);

  console.log(`\\def\\avgFScore{${avergage(f1s)}}`);
  console.log(`\\def\\medFScore{${median(f1s)}}`);

  console.log(`\\def\\avgBinnaclePrecision{${avergage(binnaclePrecisions)}}`);
  console.log(`\\def\\medBinnaclePrecision{${median(binnaclePrecisions)}}`);

  console.log(`\\def\\avgBinnacleRecall{${avergage(binnacleRecalls)}}`);
  console.log(`\\def\\medBinnacleRecall{${median(binnacleRecalls)}}`);

  console.log(`\\def{\\avgBinnacleFScore{${avergage(binnacleF1s)}}`);
  console.log(`\\def\\medBinnacleFScore{${median(binnacleF1s)}}`);
}

if (require.main === module) {
  main();
}
