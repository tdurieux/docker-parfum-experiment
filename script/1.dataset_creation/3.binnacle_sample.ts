import { basename, join } from "path";
import { walkSync } from "../utils";
import config from "../../config";
import { copyFileSync } from "fs";

// https://www.calculator.net/sample-size-calculator.html?type=1&cl=95&ci=5&pp=50&ps=178452&x=84&y=9
const SAMPLE_SIZE = 384;

function getRandomSubarray(arr: any[], size: number) {
  var shuffled: any[] = [...arr],
    i: number = arr.length,
    temp: any,
    index: number;
  while (i--) {
    index = Math.floor((i + 1) * Math.random());
    temp = shuffled[index];
    shuffled[index] = shuffled[i];
    shuffled[i] = temp;
  }
  return shuffled.slice(0, size);
}

const files = walkSync(
  join(config.dataFolder, "reproduction/deduplicated-sources")
);
const sample = getRandomSubarray(files, SAMPLE_SIZE);
for (const file of sample) {
  copyFileSync(
    file,
    join(config.dataFolder, "reproduction/sample", basename(file))
  );
}
