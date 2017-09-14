---
layout: post
title: "How to copy a heroku database between enviroments (apps)"
date: 2014-07-16 17:54
---

Lets say you have two enviroments running as Heroku apps. These will be the stage and production enviroments accordingly:

* app-stage
* app-prod

How, you've noticed that the data on the stage is lagging begind, is corrupted do to some strange code-fu, and you just want to get it up and running again with production data.

    heroku pgbackups:capture --expire -a app-prod # make a backup of the database
    heroku pgbackups:restore HEROKU_POSTGRESQL_COPPER -a app-stage `heroku pgbackups:url -a app-prod`

You will be asked to input the application name to confirm a potentially destructive action. Also - if you have another database than `HEROKU_POSTGRESQL_COPPER` you will need to change that part.
