# Advent of Code 2022

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the same
directory as the file.

## Solution comments in reverse order

Running score: 27 / 30

### Day 15: Beacon Exclusion Zone

A tough but fun one. I had flashbacks to the damn 3D beacons in ... 2019? (still not solved!) but this was much easier.

Part 1 was binary search (both ends). I guessed the area would be contigous. And of course it was, as part 2 proved. 

I figured out that if you checked the first cells outside the Manhattan circle you would have a much smaller search space. 

Score: 2

Rating: 4/5

### Day 14: Regolith Reservoir

Cobbled together a solution beased on 2018 day 17.

Score: 2

Rating: 4/5

### Day 13: Distress Signal

I took a punt on today and found a nice perlish solution in the daily solutions thread. Credit in source!

Score: **0**

Rating: 3/5

### Day 12: Hill Climbing Algorithm

Basic pathfinding. I really need to put these things into a library or somethnig.

Score: 2

Rating: 3/5

### Day 11: Monkey in the Middle

A fun Sunday problem!

Score: 2

Rating: 4/5

### Day 10: Cathode-Ray Tube

Register Rodeo - but with timings!

A fun problem. The test input was nicely designed to ensure I caught my off-by-one error.

Score: 2

Rating: 4/5

### Day 9: Rope Bridge

Another challenging puzzle. My first attempt was to move the head
directly, then "trace" the path of the tail. This worked fine for the
example but my real input was off by some tens, which made it really
hard to debug.

I then switched to a model where the tail directly followed the head
through each step.

Score: 2

Rating: 4/5

### Day 8: Treetop Tree House

As usual, a bit fiddly with all the different directions and repeated code. 

Score: 2

Rating: 3/5

### Day 7: No Space Left On Device

This was a tough one. I had the right basic idea but had to search for some hints in the subreddit. Credit /u/Abigail:

[https://github.com/Abigail/AdventOfCode2022/blob/master/Day\_07/solution.pl](https://github.com/Abigail/AdventOfCode2022/blob/master/Day_07/solution.pl)

Score: **1**

Rating: 4/7, tough but fair

### Day 6: Tuning Trouble

An easy problem. I'm happy I went with my first instinct (using the
number of hash keys to detect (lack of) duplicates), along with
parametrizing the window size, because that made part 2 trivial. That
said my finishing standings were in the 16,000s despite a personal
best finishing time this year.

Score: 2

Puzzle rating: 3/5, too easy to make this really interesting.

### Day 5: Supply Stacks

A typical AoC problem: massaging the input into a usable form is half the problem 😉

Score: 2

Puzzle rating: 4/5, mostly because I'm proud of my input wrangling

### Day 4: Camp Cleanup

Sundays are traditionally hard but it's early days and this was
suspiciously easy. Maybe people would try to expand the quite
complicated condition in part 1 to part 2 instead of looking at the
obvious solution which was to find the ranges that _didn't_ overlap
and subtract those from the total.

Score: 2

Puzzle rating: 3/5

### Day 3: Rucksack Reorganization

A bit fiddly with all the indices but not too hard once I worked it all out.

Score: 2

Puzzle rating: 3/5

### Day 2: Rock Paper Scissors

This wasn't the easiest to plan out. There were too many repeated
logic lines that I wanted to consolidate. I made a bet on part 2 that
didn't really pan out so had to rearrange a lot. This result is what's
left after cleanup.

Score: 2

Puzzle rating: 2/5, personal opinion. There's too much logic scattered
all over the place and even the "clever" solutions using modulo
arithmetic just hardcode everything.

### Day 1: Calorie Counting

Easy start, as expected. I had some issues with my first solution, I
tried to sort the `%data` hash per the sums of its elements but for some
reason must have gotten the references wrong. Reworked to store the
running sums directly. At least I got to use the seldom used `values`
function.

Update: I figured out that sorting like this

`for my $elf (sort {sum @{$data{$b}} <=> sum @{$data{$a}} } keys %data)`

you need to explicitely use `sum()` with parentheses so as not to
slurp in everything else.

Of course, doing it like that will only give you the _index_ of what
you want anyway, so you might just as well use a list from the get-go.

Score: 2

Puzzle rating: 3/5. Nothing special.

