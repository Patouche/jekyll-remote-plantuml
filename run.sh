#!/bin/bash

#CONSTANTS
CURRENT_DIR=$(readlink -f $(dirname $0))

# Go to the current directory
cd $CURRENT_DIR;

# Functions
function checkStatus() {
	if [ $1 -ne 0 ] ; then echo "Error..."; exit $1; fi
}

function log() {
	echo "";
	s="===============================";
	echo "$s"
	echo "$1"
	echo "$s"
}

# Cleaning previous build
find . -type f -name "*.gem" -delete

# Get the Gem
GEMSPEC=$(find . -name "*.gemspec")

# Building
log "Building ..."
gem build $GEMSPEC
checkStatus $?

# Running tests
log "Running tests ..."
rake test
checkStatus $?

# Installing
GEM=$(find . -type f -name "*.gem")
log "Installing ..."
gem install $GEM --verbose
checkStatus $?

# List
GEM_NAME=$(basename ${GEMSPEC%.*})
log "List $GEM_NAME"
gem list -r $GEM_NAME
gem list $GEM_NAME

# Publishing ?
echo ""
read -p "Publishing ? [y/n] " pub;
if [[ "$pub" == "y" ]] ; then
	log "Starting publishing ..."
	gem push $GEM --verbose
fi
