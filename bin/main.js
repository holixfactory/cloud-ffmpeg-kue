#!/usr/bin/env node

const Kue = require('kue');
const CloudFFmpeg = require('cloud-ffmpeg');

const config = {
  tempPath: '/tmp/cloud-ffmpeg/'
};

var cloudFFmpeg = new CloudFFmpeg(config);

var queue = Kue.createQueue({
  redis: {
    port: 6379, // default
    host: "192.168.231.223",
    auth: "temp1234",
  }
  // or simply...
  // redis: 'redis://example.com:1234?redis_option=value&redis_option=value'
});

// Run UI
Kue.app.set('title', 'cloud-ffmpeg');
Kue.app.listen(3000);

queue
  .on('error', err => {
    console.log('Enqueue error!');
    console.log(err);
  })
  .on('job remove', () => {
    cloudFFmpeg.emit('kill');
  });

queue.watchStuckJobs(500);

queue.process('cloud-ffmpeg', (job, done) => {
  let ffmpegTask = cloudFFmpeg.run(job.data)
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
});
