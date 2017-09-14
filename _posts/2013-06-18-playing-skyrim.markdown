---
layout: post
title: Skyrim - a wonderful, flawed game
---

Following a long overdue workstation change and a following GPU upgrade to the
GTX 670, I've started playing a game that has long been on my "to play" list, but
to date, I didn't have the hardware to play it.

## Enter Skyrim - the good

The Elder Scrolls is a venerable saga of cRPGs that have, as long as I can remember,
stood out as some of the most "open-ended" games possible. The world that you can
explore (after some mandatory running in the beginning) is really breath-taking.

I can rarely say that a game world feels natural enough that you can genuinely feel
that it is a place where people (and beasties) live independent of the player. But
this is definitely the case in Skyrim. People talking on the streets just for the
ambience, animals running around, different factions clashing - that's the kind of
thing that can lead to total immersion and feel truly great if you want an
authentic RPG experience.

Another thing is that the game will not restrict your freedom for your safety. You are
free to roam the world and get into fights that you cannot possibly win (mammoths, anyone?).
You are free to explore and enter areas that are not meant for your character level.

All of that, combined with the breath-taking graphics and beautiful level design takes for
a really enjoyable experience.

## The bad

The only flaw I've encountered is the enemy AI.

Playing a spell caster, fleeing is a common
strategy. When encountering another spell caster with more health I would expect the AI
to gauge it's superiority, and come after me and try to finish the job. Instead - hiding
downstairs and waiting for a magicka replenishment seems to put the foe at ease (despite the
fact that their health does not regenerate). I have defeated a foe with 6 of these retreats,
when all it had to do was to come at me with full force and I wouldn't stand a chance.

Another thing - luring a Giant to a place where he can't go in (a watchtower door for example)
will result in the giant walking up to the door and hitting the ground, while I sit comfortably
inside and throw spells at him, just waiting for my magicka to recover (I've gone as far as to
take a tea break in between).

The above flaws really break immersion in a way that is really regrettable. I've dabbled in AI
design as a teenager, event in something akin to this, and I can safely say that these are really
simple things compared to the rest of the game. Consider the following code sample from the point
of view of the beastie:

```ruby

me.attack() if me.spellcaster? and player.spellcaster? and me.magicka > player.magicka and player.health*3 < me.health
me.flee() if me.brute? and player.spellcaster? and !me.can_find_path_to(player)

```

Of course this is an oversimplification, but the mere fact that this is a rather simple concept
bothers me and takes some fun out of gaming. Hopefully this will be handled by a patch in the future.

## Ahead

I've just played the game for about 10 hours, so I think I've barely scratched the surface. Despite
it's shortcomings, Skyrim is an immensely enjoyable game that will hopefully give me many more hours of fun.
