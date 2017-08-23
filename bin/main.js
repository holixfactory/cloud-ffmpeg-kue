#!/usr/bin/env node

const Kue = require('kue');
const CloudFFmpeg = require('cloud-ffmpeg');
const program = require('commander');

program
  .version('0.1.0')
  .option('-p, --port [port]', 'Select the port for express based web-UI (defaults to 3000)')
  .option('-q, --prefix [prefix]', "Prefix for message queue (defaults to 'q')")
  .option('-r, --redis-url <url>', 'Url path to redis')
  .option('-t, --temp-path [path]', "tempPath for cloud-ffmpeg object (defaults '/tmp/cloud-ffmpeg/')")
  .option('-w, --web-title [string]', "Give a title for the web-UI (defaults to 'cloud-ffmpeg')")
  .parse(process.argv);

if (program.redisUrl === undefined) {
  console.log('Redis url must be provided!');
  process.exit();
}

// Parsing redis url into an object
let redisConfig = {};
let redisURL = program.redisUrl;
redisURL = redisURL.split('//')[1];
redisURL = redisURL.split('@');
if (redisURL.length > 1) {
  redisConfig.auth = redisURL.shift().split(':')[1];
}
redisURL = redisURL[0].split(':');
redisConfig.host = redisURL.shift();
redisURL = redisURL[0].split('/');
redisConfig.port = redisURL.shift();
if (redisURL.length > 0) 
  redisConfig.db = parseInt(redisURL.pop());
// Finish parsing redis url

const config = {
  tempPath: program.tempPath || '/tmp/cloud-ffmpeg/'
};

var queue = Kue.createQueue({
  prefix: program.prefix || 'q',
  redis: redisConfig
});

// Run UI
Kue.app.set('title', program.webTitle || 'cloud-ffmpeg');
Kue.app.listen(parseInt(program.port) || 3000);

queue.watchStuckJobs(500);
queue
  .on('error', err => {
    console.log(err);
  });

queue.process('cloud-ffmpeg', (job, ctx, done) => {
  let cloudFFmpeg = new CloudFFmpeg(config).run(job.data)
    .on('error', error => {
      done();
      console.log(error);
    })
    .on('progress', progress => {
      if (parseFloat(progress.percent) !== NaN)
        job.progress(Math.round(progress.percent), 100, progress);
    })
    .on('end', () => {
      done();
      console.log("FFmpeg task completed!");
    });
  job.subscribe(() => {
    job.on("remove", (id, type) => {
      if (type === "cloud-ffmpeg")
        cloudFFmpeg.emit('kill');
    });
  });
});
