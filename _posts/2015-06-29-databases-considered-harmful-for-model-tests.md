---
layout: post
title: "Stressed about model tests hitting the database in Rails 4.2? Here's the solution"
date: 2015-06-18 21:22
tags: rails, ruby
---
**Disclaimer**: this is more of a rant and a story about a lack of solution  than it is a actual how-to. If you're looking for answers, you will only have more questions at the end of this.


## Obligatory background story

I've been working a bit on re-writing my previous personal accountability system[1]. I've decided to code the the front-end in Ember as I previously did.

I wanted to do it properly this time, so I started with a way to properly communicate between the front end and the API using an authentication token. I found the `ember-simple-auth-devise` package and started implementing.

As I went throught the [instructions](https://github.com/simplabs/ember-simple-auth/tree/master/packages/ember-simple-auth-devise) I wound up with something like this in the standard `Devise` user:

~~~ruby

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :ensure_authentication_token

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

 # ... and so on
end
~~~

That's pretty standard. Implemented and moved on.

As I began to write my very first test to check this functionality I wound up with the following piece of code:

~~~ruby
class UserTest < ActiveSupport::TestCase
  let(:user_new)   { User.create!(email: 'user1@example.com') }

  describe "for new user" do
    it "should generate a new token on instantiation" do
      user_new.authentication_token.wont_be_empty
    end
  end
end
~~~

Some uneasy feeling crept up my spine. As I stared into the `1 runs, 2 assertions, 0 failures, 0 errors, 0 skips` result, I tried to place that feeling.

Then I remembered when I first saw the standard Rails model setup, several years back. Coming from the much frowned upon world of PHP, I was flabbergasted to see that Rails models aren't what I was used to: they were models, storage handlers, entity repositories and authentication handlers all in one package.

Later on I've realised the fast development pace and verbostiy these conventions can provide *if* used appropriately.

Then came real life. Every project I've worked on since (apart from some personal ones) were big projects. Most of them have been developed for more than 1 year before I stepped in. Every single one of them had a suite of tests that took far too long to run.

I'm not talking about a David Brady 7 second Twitter limit type tests, I'm talking 1~5 minutes just to run the model tests! Add some integration tests and this comes up to 20 minutes.

Of course you learn to code around this. Tools like `guard` do a decent job of running only what you are working on, and CI enviroments take care of asynchrounously making sure that something didn't break somewhere else.

And yet...

That `create!` kept taunting me. That one test represents the suffering in those projects forgotten, the thousand hours wasted, those processing cycles. Tear down database -> update schema -> import fixtures; all to check if a value is not empty. Thousands of times...

**NO!** Not on my watch. Not in my personal project done for fun.
A quick [change](https://github.com/GregPK/cat_squeel-api/commit/eb0bbed042bd98de2e41c1ba2188ca8c8766b875) and the database is no longer in the loop.

But this should not be end. This was the first test and already I have almost tied my model tests to the database. A bit of code pasted from another site and best practices are overlooked just like that.

I need the killer feature of the best frameworks, the best practice of the elite: I need to kill the convenience of making a short-sighted decision. I need to make it HARD to use the database in model tests.

## A soliloquy on the path less traveled

You might suggest that by trying to cut ActiveRecord out of my tests I'm merely putting on a band-aid, that I haven't gone far enought. That if I whine about AR so much I should just use something else.

Here's the thing: I have come to believe the following things:

 * learning one thing at a time is the best way to go,
 * shipping is a skill,
 * if you're doing something for the first time, use the smallest case you can find.

If would use something like Sequel or Ruby Object Mapper, or even the Grape api gem with Entities and whatnot, I might avoid the problem I'm describing here, but I would encounter a 100 others. I've done it before on smaller projects - I know what I'm talking about.

This project is mostly about me learning Ember, making an API that people might want to contribute to and making something useful for myself. By using something that is not the standard solution, I would violate every one of the above rules.

## Discarded solutions

Interestingly enough, this is not a really contested subject on the internet. The solutions are a bit hard to find and might be a bit dated. I stumbled upon several broken ones - I'm listing them here to give you an idea of how exotic this idea is.

* [Unit Record](https://github.com/dan-manges/unit-record) - v 0.9.1 - threw errors
* Using RSpec's `config.around` to stub out the AR connection as described [in this post](http://pivotallabs.com/testing-strategies-rspec-nulldb-nosql/) (section 'Testing using stubs')
* Using RSpec and [nulldb](https://github.com/nulldb/nulldb) - I've encountered this [issue](https://github.com/nulldb/nulldb/issues/63).

## Solution

The rundown is:

1. Give up
2. Read the [assurance by DHH](http://david.heinemeierhansson.com/2014/slow-database-test-fallacy.html) that everything is fine.
3. Repeat "Everything is fine" 10 times.
4. Write a flippant blog article.
5. Go back to coding, ie. doing actual work.

Bonus advice: These are the pro-tips for programming that should help you keep safe:

* Not all tests require the database.
* New objects are created by `#new` not `#create`. Really. I've looked it up in the docs and everything.
* Objects have this cool feature that if you write
~~~ruby
def initialize
  #code
end
~~~
the code part will be run after you create a new object.

Now let's ship something.

---

[1] Previously **[SIG](https://github.com/GregPK/sig)**, now the **CatSqueel** family ([API](https://github.com/GregPK/cat_squeel-api) + [Ember front-end](https://github.com/GregPK/cat_squeel-ember)
