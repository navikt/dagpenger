#!/usr/bin/env bash

git branch --all | sed 's/^[* ] //' | egrep '^main|^master' | xargs git checkout