Cloud FFmpeg Kue
====================================

`Cloud FFmpeg Kue` is a FFmpeg task queue built with [Kue](https://github.com/Automattic/kue)
and [cloud-ffmpeg](https://github.com/tntcrowd/cloud-ffmpeg).

[![npm Package](https://img.shields.io/npm/v/cloud-ffmpeg-kue.svg?style=flat-square)](https://www.npmjs.org/package/cloud-ffmpeg-kue)

Requirements
------------

- `Node.js` 6.11.x (or later)
- `cloud-ffmpeg` 1.0.7 (or later)
- `kue` 0.11.x
- Redis 4.x (or later)
- and more specified in [package.json](package.json) under dependencies

Installation
------------

Install with `npm`:

    npm install --save cloud-ffmpeg-kue


Usage
-----------------

First install dependencies via `npm`:

    cd /path/to/cloud-ffmpeg-kue
    npm install


`Cloud FFmpeg Kue` takes following options:

    Usage: main [options]


    Options:

      -V, --version             output the version number
      -p, --port [port]         Select the port for express based web-UI (defaults to 3000)
      -q, --prefix [prefix]     Prefix for message queue (defaults to 'q')
      -r, --redis-url <url>     Url path to redis
      -t, --temp-path [path]    tempPath for cloud-ffmpeg object (defaults '/tmp/cloud-ffmpeg/')
      -w, --web-title [string]  Give a title for the web-UI (defaults to 'cloud-ffmpeg')
      -h, --help                output usage information

Of these options, url for Redis is the only required option.

To execute, in any shell or terminal emulator:

    cloud-ffmpeg -r redis://:password@xxx.xxx.xxx.xxx:6537/
    

Dockerfile
-----------------

Dockerfile to build Docker image is included in this repository. The image is
based on Alpine Linux 3.4 and includes FFmpeg v3.3.3 and node.js v6.11.2 and 
necessary dependencies to build them. For build instructions, refer to 
[Dockerfile reference](https://docs.docker.com/engine/reference/builder/) from 
the Docker docs.


License
-------

Copyright (c) 2017, TNTcrowd Co., Ltd.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
