#!/bin/bash

ffmpeg -i rtmp://stream.engineers.sg/live/test -f image2 -vf fps=1/5 /var/html/screenshots/snapshot%05d.jpg
