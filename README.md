# RUBLE - T1A3 Assessment
### A Ruby Terminal Based replica of the game 'Wordle'
### - By Christopher (Chris) Hullman

## About Ruble

Ruble is a Ruby developed terminal app replica of the real-world word game called "Wordle", of which can be played here: https://www.nytimes.com/games/wordle/index.html (last viewed 24/04/2022) Instead of that game giving you only 1 wordle per day, however, Ruble gives you a new Wordle to try and guess on every play-through! (UNLIMITED PLAYABILITY!)

## Usage

**Step 1)** Ensure you meet the **system requirements** (see heading *Tested System Requirements* below), which includes having Ruby version 2.7.1 or higher installed, and a Bash terminal.

**Step 2)** 
- Git clone this master repository, or download the ZIP and extract it somewhere.
- In your Bash terminal, browse to the `src/` directory.

**Step 3)** Ensure correct directory and file permissions (**this likely shouldn't be an issue, however!**)
- The `src/` directory must have WRITE permission.
- All files in `src/` and its sub-directories must have READ permissions.
- In addition to the above, the shell file `src/run_main.sh` must have EXECUTE permission.

**Step 4)** Download and install the `Bundler` gem: Run `gem install bundler` in your terminal.

**Step 5)** Run `./run_main.sh` **to play the game!**

(This shell script will install all required gems and dependencies, and then execute the command `ruby main.rb`)

**Optional)**
- To display 'How To Play' instructions only, run `./run_display_help.sh`
- To run Rspec tests, run `./run_tests.sh`

#### How To Play Ruble

You will have 6 attempts to guess a randomly selected, valid 5 letter English word, known as the Wordle, by inputting letters 'a' to 'z' to form a valid 5 letter English word as your guess.