## Notes
My approach here was to use TDD to implement the solution incrementally. You'll notice in the git history that each of my commits is either a test 
and the accompanying production code, or a refactoring step. I attempted to bite off a small part of the problem one step at a time, 
and to write a testcase for each of the stated requirements.  My next steps here would be to extract further classes from the current DrivingHistoryCalculator in order to 
make it easier to maintain.  I noticed early in the process that the problem was primarily a MapReduce issue (Do something to each of the lines, and then summarize them.), which 
is reflected mostly in the `DrivingHistoryCalculator.create_reported_trips` method.

### Setup
1. Insure Ruby 2.3.1 is installed (via RVM or other)
2. Install bundler if you don't already have it: `gem install bundler`
3. Execute `bundle install` from the root of the project

### Running the Tests
1. To run the tests simply execute `rake`.  The default task is to run the RSpec tests

## Usage
This script accepts input from stdin.  To execute make sure you have followed the setup instructions above, then pass input to `driving_history_reporter.rb`, which is the entry point.

Example usage: `cat input.txt | ruby driving_history_reporter.rb`

## Problem Statement

Let's write some code to track driving history for people.

The code will process an input file. You can either choose to accept the input via stdin (e.g. `cat input.txt | ruby yourcode.rb`), or as a file name given on the command line (e.g. `ruby yourcode.rb input.txt`).

Each line in the input file will start with a command. There are two possible commands.

The first command is Driver, which will register a new Driver in the app. Example:

`Driver Dan`

The second command is Trip, which will record a trip attributed to a driver. The line will be space delimited with the following fields: the command (Trip), driver name, start time, stop time, miles driven. Times will be given in the format of hours:minutes. We'll use a 24-hour clock and will assume that drivers never drive past midnight (the start time will always be before the end time). Example:

`Trip Dan 07:15 07:45 17.3`

Discard any trips that average a speed of less than 5 mph or greater than 100 mph.

Generate a report containing each driver with total miles driven and average speed. Sort the output by most miles driven to least. Round miles and miles per hour to the nearest integer.

Example input:

```
Driver Dan
Driver Alex
Driver Bob
Trip Dan 07:15 07:45 17.3
Trip Dan 06:12 06:32 12.9
Trip Alex 12:01 13:16 42.0
```

Expected output:

```
Alex: 42 miles @ 34 mph
Dan: 30 miles @ 36 mph
Bob: 0 miles
```
