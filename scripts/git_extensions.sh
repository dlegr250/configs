#!/bin/bash

#======================================================================
# Desc: Adds convenient extensions/aliases to Git via shell scripts.
# Maintainer: Dan LeGrand
# * Functions prefixed with '__' are script-related functions and
#   should not be called by external scripts.
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

# Absolute URL of git repo
__git_repo_url() {
  git ls-remote --get-url
}

__current_git_branch() {
  git rev-parse --abbrev-ref HEAD
}

# Used by specialized create branch functions
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
    # feature: from develop to develop (deploy to development/test)
    # bug:     from develop to develop (deploy to development)
    # release: from develop to develop/master (deploy to production)
    # hotfix:  from master  to develop/master (deploy to development/production)

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

# Create branches
#----------------------------------------------------------------------

# New feature/... branch
# From development
feature() {
  __new_branch "feature" $(__join_text_with_hyphens $*)
}

# New bug/... branch
# From release to development/release
bug() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New refactor/... branch
# From development to development
refactor() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New release/... branch
# From development to development/master
release() {
  __new_branch "bug" $(__join_text_with_hyphens $*)
}

# New hotfix/... branch
# From master to development/master
hotfix() {
  __new_branch "hotfix" $(__join_text_with_hyphens $*)
}

# Delete branches
#----------------------------------------------------------------------

# Only delete local branch
delete_local_branch() {
  if [ -z "$1" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    local branch_name=$1
    local cmd="git branch -d $branch_name"
    echo "=> $cmd"
  fi
}

# Only delete remote branch
delete_remote_branch() {
  if [ -z "$1" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    local branch_name=$1
    local cmd="git push origin --delete $branch_name"
    echo "=> $cmd"
  fi
}

# Delete both local and remote branch
delete_branch() {
  local branch_name=$1

  # Have user confirm they want to completely delete this branch
  read -p "Are you sure? (Y/N): " -r

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Deleting branch from both local and remote repos"
    delete_local_branch $branch_name
    delete_remote_branch $branch_name
  else
    echo "Canceling delete"
  fi
}

# List/switch branches
#----------------------------------------------------------------------

# List branches ('*' marks current branch)
branches() {
  __current_dir_has_git || return
  git branch
}

# Switch to new branch
checkout() {
  __current_dir_has_git || return
  if [ -z "$1" ]; then
    echo "-----> ERROR: No branch name given!"
  else
    branch_name=$1
    local cmd="git checkout $branch_name"
    echo "=> $cmd"
    $cmd
  fi
}
