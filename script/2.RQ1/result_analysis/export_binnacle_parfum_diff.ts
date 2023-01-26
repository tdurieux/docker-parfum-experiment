import { basename, join } from "path";
import * as utils from "../../utils";
import ProgressBar from "progress";
import async from "async";
import { BINNACLE_RULES } from "@tdurieux/docker-parfum";
import config from "../../../config";
import { readFile } from "fs/promises";

(async () => {
  const binnacleViolations = join(
    config.dataFolder,
    "reproduction/results-github-individual.txt"
  );

  const mapVuln = {};

  for (const line of (await readFile(binnacleViolations, "utf-8")).split(
    "\n"
  )) {
    if (line.trim().length == 0) continue;
    try {
      const info = JSON.parse(line);
      for (const rule of BINNACLE_RULES) {
        let name = utils.smellName(rule.name);
        if (!info.all_violations[name]) {
          name = "rule" + name[0].toUpperCase() + name.slice(1);
        }
        if (!info.all_violations[name]) {
          continue;
        }
        if (info.all_violations[name].violations) {
          if (!mapVuln[info.file_sha]) mapVuln[info.file_sha] = {};
          mapVuln[info.file_sha][utils.smellName(name)] =
            info.all_violations[name].violations;
        }
      }
    } catch (error) {
      console.log(error);
    }
  }

  const rootViolations = config.defaultBinnacleAnalysisAndRepairPath;
  const violationsFiles = utils.walkSync(rootViolations);

  const bar = new ProgressBar(
    "[:bar] :current/:total :rate/bps :percent :etas :step",
    {
      complete: "=",
      incomplete: " ",
      width: 30,
      total: violationsFiles.length,
    }
  );

  const smells: string[] = BINNACLE_RULES.map((r) =>
    utils.smellName(r.name)
  ).sort();
  let line = "name";
  for (const smell of smells) {
    line += "," + smell + "," + smell;
  }
  line += ",Diff";
  console.log(line);
  async.forEachOfLimit(
    violationsFiles,
    10,
    async (path, _, callback) => {
      const filename = basename(path).replace(".json", "");
      bar.tick({ step: `${filename}` });
      if (!mapVuln[filename]) return callback();

      try {
        const viols = {};
        const info = JSON.parse(await readFile(path, "utf-8"));
        for (const v of info.originalSmells) {
          viols[utils.smellName(v.rule)] =
            (viols[utils.smellName(v.rule)] || 0) + 1;
        }
        let line = `data/reproduction/deduplicated-sources/${filename}.Dockerfile`;
        line = filename;
        let diff = 0;
        for (const smell of smells) {
          const n = viols[smell] || 0;
          const o = mapVuln[filename][smell] || 0;
          line += "," + n + "," + o;
          diff += Math.abs(n - o);
        }
        if (diff != 0) {
          console.log(line + "," + diff);
        }
      } catch (e) {
        console.error(e);
      } finally {
        callback();
      }
    },
    () => {}
  );
})();
