import { basename, join } from "path";
import config from "../../../config";
import { SIZE_RULES, smellName, walk } from "../../utils";
import { readFile } from "fs/promises";
import ProgressBar from "progress";
import { existsSync } from "fs";
import * as dockerfile from "@tdurieux/dinghy";
import { Position } from "@tdurieux/dinghy/build/docker-type";
import { Matcher, Violation } from "@tdurieux/docker-parfum";

async function main() {
  const consolidatedResults = {};
  for (let rule of SIZE_RULES) {
    consolidatedResults[rule.name] = [];
  }
  let index = 0;
  let nbSmellyDockerfile = 0;
  const bar = new ProgressBar(
    "[:bar] :current :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: 384,
    }
  );
  await walk(config.groundTruthSmells, async (path) => {
    bar.tick({ step: basename(path) });
    const groundTrust: { [key: string]: Partial<Position>[] } = JSON.parse(
      await readFile(path, "utf-8")
    );
    if (
      Object.keys(groundTrust).filter((k) => consolidatedResults[k]).length > 0
    ) {
      nbSmellyDockerfile++;
    }
    const dockerfilePath = join(
      config.groundTruthDockerfiles,
      basename(path).replace(/\.json$/, ".Dockerfile")
    );
    const parfumResult: Violation[] = [];

    let ast = null;
    try {
      ast = dockerfile.parseDocker(dockerfilePath);
    } catch (error) {
      if (error.ast) {
        ast = error.ast;
      }
    }
    if (ast !== null) {
      const matcher = new Matcher(ast);
      for (const rule of SIZE_RULES) {
        try {
          matcher.match(rule).forEach((e) => parfumResult.push(e));
        } catch (error) {
          console.log(error);
        }
      }
    }

    let binnacleResult = { all_violations: {} };
    if (existsSync(`docs/data/results/binnacle/${basename(path)}`)) {
      binnacleResult = JSON.parse(
        await readFile(`docs/data/results/binnacle/${basename(path)}`, "utf-8")
      );
    }

    for (const smell in groundTrust) {
      if (!consolidatedResults[smell]) {
        continue;
      }
      consolidatedResults[smell].push({
        file: basename(path),
        groundTruth: groundTrust[smell],
        parfum: parfumResult.filter((p) => p.rule.name === smell),
        binnacle: binnacleResult.all_violations[smell] || 0,
      });
    }
  });
  for (const smell in consolidatedResults) {
    let parfum = 0;
    let binnacle = 0;
    let groundTruth = 0;
    for (const result of consolidatedResults[smell]) {
      groundTruth += result.groundTruth.length;
      parfum += result.parfum.length;
      binnacle += result.binnacle;

      if (result.groundTruth.length != result.parfum.length) {
        console.log(
          result.file,
          smell,
          result.groundTruth.length,
          result.parfum.length,
          result.binnacle
        );
      }
    }
    console.log(
      `${smellName(
        smell
      )} & \\np{${groundTruth}} & \\np{${parfum}} & \\np{${binnacle}}\\\\`
    );
  }

  console.log(`\\def\\nbDockerfilesGroundTruth{${index}}`);
  console.log(
    `\\def\\nbDockerfilesGroundTruthWithSmell{${nbSmellyDockerfile}}`
  );
}

if (require.main === module) {
  main();
}
