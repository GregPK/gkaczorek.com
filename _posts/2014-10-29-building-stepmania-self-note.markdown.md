---
layout: post
title: "Building Stepmania from Source on Ubuntu"
date: 2014-10-29 21:48
comments: true
published: true
---

Just a reminder for the next time I need to build Stepmania from source.

First of all, the process is here:
http://ec2.stepmania.com/wiki/Build_the_StepMania_Source_in_Linux

And here is the bulk script that can be copy pasted into the console:

```bash
#install dependencies
sudo apt-get install autoconf automake mesa-common-dev libglu1-mesa-dev libxtst-dev libxrandr-dev libpng12-dev libjpeg8-dev zlib1g-dev libbz2-dev libogg-dev libvorbis-dev libc6-dev yasm binutils-dev libgtk2.0-dev libmad0-dev
#and then:
git clone https://github.com/stepmania/stepmania.git && \
cd stepmania && \
./autogen.sh && \
./configure && \
make && \
cp src/GtkModule.so ./ && \
cp src/stepmania ./
```
