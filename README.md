# Advent of Code 2022

I use Perl for all the solutions.

Most assume the input data is in a file called `input.txt` in the same
directory as the file.

## Solution comments in reverse order


### Day 6: Tuning Trouble

An easy problem. I'm happy I went with my first instinct (using the
number of hash keys to detect (lack of) duplicates), along with
parametrizing the window size, because that made part 2 trivial. That
said my finishing standings were in the 16,000s despite a personal
best finishing time this year.

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

