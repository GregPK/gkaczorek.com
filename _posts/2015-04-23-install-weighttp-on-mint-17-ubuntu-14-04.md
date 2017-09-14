---
layout: post
title: "Installing weighttp on Linux Mint 17 (or Ubuntu 14.04)"
date: 2015-04-23 09:50
comments: true
published: true
---

I wanted to do some load impact tests on one of the apps I'm currently working
on and I read about __weighttp__. Unfortunately the instructions on the git repo
as well as some other placed left out a crucial piece of information, I got:

    Checking for library ev  : not found

Usually this is solved by some variant of `apt-get install lib#{lib_name}`, but
in this case you have to do:

    sudo apt-get install libev4 libev-dev

So the whole process for my machine is:

```
sudo apt-get install libev4 libev-dev
git clone git://git.lighttpd.net/weighttp
cd weighttp
./waf configure
sudo ./waf install
```

And that's it, enjoy killing servers :)


