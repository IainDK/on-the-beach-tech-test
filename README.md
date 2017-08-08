# On The Beach Tech Test

This exercise was completed using Ruby 2.3.1 and RSpec 3.5

## Setting-up

1. Clone this repository
2. Create and enter a new directory, and run `git init` via the command line
3. Run `git remote add origin https://github.com/YOURNAME/on-the-beach-tech-test.git`
4. Run `git pull origin master`
4. Run `bundle`
5. Run RSpec to execute to tests

## Requirements

Imagine we have a list of jobs, each represented by a character. Because certain jobs must be done before others, a job may have a dependency on another job. For example, a may depend on b, meaning the final sequence of jobs should place b before a. If a has no dependency, the position of a in the final sequence does not matter.

* Given you’re passed an empty string (no jobs), the result should be an empty sequence.

* Given the following job structure:

```
a =>
```

The result should be a sequence consisting of a single job a.

* Given the following job structure:

```
a =>
b =>
c =>
```
The result should be a sequence containing all three jobs abc in no significant order.

* Given the following job structure:

```
a =>
b => c
c =>
```
The result should be a sequence that positions c before b, containing all three jobs abc.

* Given the following job structure:

```
a =>
b => c
c => f
d => a
e => b
f =>
```

The result should be a sequence that positions f before c, c before b, b before e and a before d containing all six jobs abcdef.

* Given then following structure:

```
a =>
b =>
c => c
```
The result should be an error stating that jobs can’t depend on themselves.

* Given the following structure:

```
a =>
b => c
c => f
d => a
e =>
f => b
```

The result should be an error stating that jobs can’t have circular dependencies.

## My Approach

### Practices Followed

I completed the exercise using TDD, following the Red/Green/Refactor cycle. My process looked like this:

1. Write a failing test for the requirement
2. Make the test pass in the most basic way possible
3. Refactor the code when possible

At two points during the time of creating the program, I realised that a big refactoring job was necessary. For these cases, I created separate branches to work on.

Multiple tests were written for the more complex requirements - particularly step 5 and step 7 - to ensure the program was working as intended.

### The Logic behind the Code

```
{ job => dependency }
```

Given that every job will always be present in the final sequence, I started by pushing all jobs inside of an array. I then iterated through a hash (in the structure seen above) to check if the dependency was present inside of the array (some dependencies were blank). If the dependency existed, I would then insert it into the array before the index of the job.

A simple demonstration to help visualise the process:

```
job_hash = { a => , b => c, c => }
```

This is our job hash. Here, b relies on c, and as such, c must come before b in the final sequence.

```
job_array = [a, b, c]
```

Firstly, an array is formed using all of the hashes keys.

```
job_hash.each do |job, dependency|
```

The job hash will then be iterated through to check if the dependency exists inside of `job_array`.

```
job_array = [a, c, b, c]
```

Providing that it does, the dependency will then be pushed into the array using the index of the job.

```
job_array = [a, c, b]
```

Lastly, I then used the built in Ruby method `.uniq` to eliminate all duplicates of the dependency. As the method will always retain the first first occurrence of an element, this seemed perfect for the job.

```
job_array.index(dependency) > job_array.index(job)
```

I used similar logic for detecting circular dependencies. I performed a check to find out if any of the job's dependency indexes were higher than that of the job index itself. If this returned true at any point, then I knew I could raise an error.
