---
layout: post
title: "How to triage bad SOLR indexing models"
date: 2015-06-03 23:16
---

Simple script to see which SOLR indexes build the longest.

## Problem

* After running `sunspot:solr:reindex`, the reindexing takes and ungodly amount of time (several hours)
* You have an important release coming up
* You want to see which searchable model is causing trouble without manually going through them all (there is about 40)

## Solution

Here is the rake task i use:

~~~ruby

require 'benchmark'

desc 'run each model reindex in isolation, with benchmarking info on the time it takes'
task solr_reindex_benchmark: :environment do
  Rails.application.eager_load!

  # slow models are the ones that take > 10 second in development, the slowest are at the very end
  # this is very useful when one models hold up indexing for the whole website and it has to be tracked down
  slow_models = [Snail, Turtle, Mail, AnyPolitician]
  # these are models that we should skip - they are currently broken and will not index in any sensible timeframe
  skip_models = [BreakingModel]

  reindexable_ar_models = ActiveRecord::Base.descendants.select{ |c| c.respond_to?(:reindex)}.reject{ |c| (slow_models+skip_models).include?(c) }

  reindexable_ar_models += slow_models

  max_class_name_len = reindexable_ar_models.map{|kl| kl.name.length}.max
  Benchmark.bm(max_class_name_len) do |x|
    reindexable_ar_models.each do |klass|
      x.report(klass.to_s) do
        ActiveRecord::Base.logger.silence do
          klass.send :reindex
        end
      end
    end
  end

end

~~~

To use this task:

1. Run it, wait for first model that takes > 5 seconds
2. Add that model, ie. `Turtle` into the `slow_models` array
3. Repeat steps 1 & 2 until you reach the one that is the problem.

Pretty fast way of figuring that out.
