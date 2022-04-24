# RUBLE - T1A3 Assessment
### A Ruby Terminal Based replica of the game 'Wordle'
### - By Christopher (Chris) Hullman

## About Ruble

Ruble is a Ruby developed terminal app replica of the real-world word game called "Wordle", of which can be played here: https://www.nytimes.com/games/wordle/index.html (last viewed 24/04/2022) Instead of that game giving you only 1 wordle per day, however, Ruble gives you a new Wordle to try and guess on every play-through! (UNLIMITED PLAYABILITY!)

## GitHub Source Respository Link

**[https://github.com/chullman/ruble](https://github.com/chullman/ruble)**

## Usage

**Step 1)** Ensure you meet the **system requirements** (see heading *Tested System Requirements* below), which includes having Ruby version 2.7.1 or higher installed, and a Bash terminal.

**Step 2)** 
1. Git clone this master repository, or download the ZIP and extract it somewhere.
2. If following the *Tested System Requirements* heading below, open Ubuntu 20.04 to use as your Bash terminal environment.
    - Alternatively, for other systems like Mac OS or a dedicated Linux system, Bash terminal can be directly be accessed from your system, or from 'VS Code', for example, if you're using 'VS Code' as your IDE.
3. In your Bash terminal, browse to the `src/` directory.

**Step 3)** Ensure correct directory and file permissions (**this likely shouldn't be an issue, however!**)
- The `src/` directory must have WRITE permission.
- All files in `src/` and its sub-directories must have READ permissions.
- In addition to the above, the shell file `src/run_main.sh` must have EXECUTE permission.

**Step 4)** Download and install the `Bundler` gem: Run `gem install bundler` in your terminal.

**Step 5)** Run `./run_main.sh` **to play the game!**

**Alternative Manual Usage)**
1. Follow **Steps 1 to 4** above, as normal
2. Run `bundle` in terminal to install the gems from the Gemfile
3. Run `ruby main.rb` **to play the game!**
- OR run `ruby main.rb help` to display only the 'How To Play` instructions.
- OR run `rspec` to run the tests in the `spec/` directory.

**Optional Steps)**
- To display 'How To Play' instructions only, run `./run_display_help.sh` (**This will pass in the `help` command line argument to the main Ruby file**)
- To run Rspec tests, run `./run_tests.sh`

#### How To Play Ruble

You will have 6 attempts to guess a randomly selected, valid 5 letter English word, known as the Wordle, by inputting letters 'a' to 'z' to form a valid 5 letter English word as your guess. **Please select `Read 'How To Play'` in the in-game menu selection for more information**

## Tested System Requirements

- Ruby 2.7.1 or greater installed and added to the system/user environment variable path
- Internet access - to download and install all gems required for the app
- Windows 10 (64-bit and Build 19041 or higher) with WSL enabled and installed and Ubuntu 20.04 WSL app installed
    - This should also include Bash terminal
- At least 8 GB memory
- At least 2 GB disk space for WSL
- At least 1 GHz single-core CPU

## Software Implementation Plan - Trello

**Trello link:** [https://trello.com/b/V7q9Pmvl](https://trello.com/b/V7q9Pmvl)

**Trello progress screenshots:** Please browse to the `/docs` directory in this master repository.

## App Features

**Feature Descriptions:**

**Feature #1** See Trello card [https://trello.com/c/zBwQe3Kp](https://trello.com/c/zBwQe3Kp)

**Feature #2** See Trello card [https://trello.com/c/YAlDbozF](https://trello.com/c/YAlDbozF)

**Feature #3** See Trello card [https://trello.com/c/M6S1vNP5](https://trello.com/c/M6S1vNP5)

**Misc. Feature** See Trello card [https://trello.com/c/Lx7wbJz7](https://trello.com/c/Lx7wbJz7)

## Slide Deck

See PDF file `ChristopherHullman_T1A3_Slide_Deck.pdf` in `ppt/` directory.

## Ruby Gems Used

- json 2.6
- net-http 0.2.0 (*In Gemfile, but not currently used by app as it stands*)
- colorize 0.8.1
- tty-table 0.12.0
- tty-prompt 0.23.1
- prawn 2.4
- artii 2.1
- rspec 3.11

(This includes all dependencies automatically required by the above listed gems)

## Known Issues

#### and possible future fixes

- The collection of all 5-letter words used and recognised by the app may contain some words that are offensive, rude or vulgar, including euphamisms.
- Some normally valid English 5-letter words aren't recognised by the app as they weren't in the dictionary I sourced the words from, for whatever reason.
    - This includes plurals like 'women'.
- Some 5-letter words recognised by the app shouldn't be because they were in the dictionary I sourced the words from.
    - This includes country-specific English words and some slang words.
    - As well as proper nouns.
- Word guess results won't display correctly to the user if their terminal window is too small.
- Text being too small to read unless the user manually zooms in on their terminal window.
- If the PDF file cannot be generated (likely due to file/directory permissions error), there is no option for the user to **retry** generating the PDF once they fix the issues without starting a new game.
- No option currently for colour-blind users. This app is entirely dependent on the users being able to see the colours GREEN, ORANGE and GREY.
- No option to see the definition for a chosen Wordle. This may be implemented as a future feature, but would require the app to be online-connected to source the word definition every time.

## Code Style Guide

- Using snake_case for variable names, method names, and file names.
- Using CamelCase for class names
- I used 4-spaces tabs for indentation instead of recommended 2-spaces (**sorry!** I just found 4-spaces easier for me to read and debug code)
- Loops and control flow statements where chosen for best semantics and use cases to the best of my knowledge. E.g. `until TRUE` loops instead of `while NOT TRUE` loops for negative conditions, `case` statements for instances of simple control flow expressions, etc.
- No unnecessary white-space, unless to aid in readability.
- No use of `;` to terminate expressions.
- Use of `==` for equality rather than using `eql?` method.
- No override of the default file encoding of `UTF-8`.
- Empty lines inside method blocks to aid seperation of logic and thus readability to the developer.
- I used explicit `return` keywords in some cases outside of control flow handling (again, **sorry!**, but again that was personal preference of mine to ensure I know exactly what's happening with the code).
- I used explicit `begin` keywords as I didn't know at the time that this was against convention.

**Style Guide Reference:** [https://rubystyle.guide/](https://rubystyle.guide/) (last viewed 24/04/2022)


