#!/bin/bash
# The 'she-bang' at the top of this script tells the system that this file is a set of commands to be fed to the command interpreter indicated

# **EXECUTE RSPEC TESTS ONLY**

# STEPS

# With reference from: https://stackoverflow.com/a/24112741 (viewed 23/04/2022)
# This is needed incase we execute this shell file from outside the directory that contains the below ruby file,
# so the below main.rb ruby file, and all subsequent relative file references, can be found from the absolute path of where this shell script is (i.e. in the src/ directory)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Install gems in Gemfile
bundle

clear

rspec