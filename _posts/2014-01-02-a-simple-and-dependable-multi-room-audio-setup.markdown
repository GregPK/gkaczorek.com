---
layout: post
title: "A simple and dependable multi-room audio setup"
date: 2014-01-02 12:13
comments: true
---


## The need

I wanted to have a simple way to stream audio in all the rooms of my 
apartment at once. Surely not a complicated matter, eh?

Research ensued, which led me through a succession of forums and blogs giving 
advice on bluetooth speakers, closed pricy systems and the ever so useful 
recomendations like "use headphones".

To reiterate, my needs were:

1. Be able to stream audio in 3 rooms at once.
2. Use an existing audio library from my hard drive.
3. Bonus points to the ability to play 2 different streams at once in individual rooms.

## The setup

I had the following situation:

* I have an HTPC/dev machine running Linux in the living room.
* I have a Linux workstation in the bedroom.
* I also have a bathroom and kitchen.


## The solution

1. Buy Raspberry Pi + WiFi dongle (for every room)
2. Buy 1 set of speakers (mine were cheap, but the quality is up to you) for every room
2. Install and setup [Logitech Media Server](http://www.ecosia.org/url?url=http%3A%2F%2Fwww.havetheknowhow.com%2FInstall-the-software%2FInstall-Squeezebox-server.html&v=2&i=2&q=logitech%20media%20server%20linux%20install&p=0&tr=0&at=0&ar=0&ab=0&mr=0&ir=0&kgr=0&nr=0&iar=0&sr=0) on the HTPC.
3. Install squeezelite on each Rasbpy and the HTPC, and the workstation.
4. Install [the Squezebox app](https://play.google.com/store/apps/details?id=com.logitech.squeezeboxremote&hl=pl) on phone (Android)
5. Party!

## Conclusions

* squeezelite is surprisingly stable and easy to install on all the machines 
  (HTPC + workstation + Rasbpy, all running different flavours of Linux)
* LMS is also very stable and handles my music library very well (tags and the like)
* You can have a multi-room setup for the price of (Raspberry+Speakers) &times; (room count)
* You can reuse existing machines (like I did with the workstation and HTPC) to trim the need for a lot of Pis.
* The Raspberry can be put with the speakers of your own choosing (you can even make your own speaker box)
* The latency between machines in quite good (on WiFi), but discernible - when different boxes are in the same room, you will hear it.
* A setup of this proportion can be completed in 2 hours.
