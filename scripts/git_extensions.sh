#!/bin/bash

#======================================================================
# Desc: Adds convenient extensions/aliases to Git via shell scripts.
# Maintainer: Dan LeGrand (dan.legrand@gmail.com)
#======================================================================

# Config
#----------------------------------------------------------------------

# NOOP

# Helper methods
#----------------------------------------------------------------------

# See: http://stackoverflow.com/a/27552913/667772
__current_dir_has_git() {
  local dir=${1:-$PWD}             # allow optional argument
  while [[ $dir = */* ]]; do       # while not at root...
    [[ -d $dir/.git ]] && return 0 # ...if a .git exists, return success
    dir=${dir%/*}                  # ...otherwise trim the last element
  done
  echo "-----> ERROR: no '.git' directory found in: '$PWD'"
  return 1                         # if nothing was found, return failure
}

__git_repo_url() {
  git ls-remote --get-url
}

__current_git_branch() {
  git rev-parse --abbrev-ref HEAD
}

__new_branch() {
  __current_dir_has_git || return
  if [ -z "$2" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    local type_of_branch=$1
    local new_branch_name=$2
    local full_branch_name="$type_of_branch/$new_branch_name"

    echo "* Repo: $(__git_repo_url)"
    echo "* From: $(__current_git_branch)"
    echo "*   To: $full_branch_name"

    # Certain types of branches can only branch from/to select branches
    # feature: from develop to develop
    # bug:     from develop to develop
    # release: from develop to develop/master
    # hotfix:  from master  to develop/master

    local cmd="git checkout -b $full_branch_name"

    echo "=> $cmd"
  fi
}

__join_text_with_hyphens() {
  local new_branch_name=""
  local i=0
  for i in "$@"; do
    new_branch_name="$new_branch_name-$i"
  done

  # Strip out leading '-'
  echo ${new_branch_name:1}
}

# Command methods
#----------------------------------------------------------------------

# New feature branch
feature() {
  __new_branch "feature" $(__join_text_with_hyphens $*)
}

# New bug branch
bug() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New refactor branch
refactor() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New release branch
release() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New hotfix branch
hotfix() {
  __new_branch "hotfix" $(__join_text_with_hyphens $*)
}

# Only delete locally
delete_local_branch() {
  if [ -z "$1" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    local branch_name=$1
    echo "* Deleting local branch: $branch_name"
    local cmd="git branch -d $branch_name"
    echo "=> $cmd"
  fi
}

# Only delete remotely
delete_remote_branch() {
  if [ -z "$1" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    local branch_name=$1
    echo "* Deleting remote branch: $branch_name"
    local cmd="git push origin --delete $branch_name"
    echo "=> $cmd"
  fi
}

# Delete branch both locally and remotely
delete_branch() {
  local branch_name=$1

  # Confirm from user
  read -p "Are you sure? (Y/N): " -r

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    delete_local_branch $branch_name
    delete_remote_branch $branch_name
  else
    echo "Canceling delete"
  fi
}
