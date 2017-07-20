# Adapted from https://gist.github.com/tswaters/542ba147a07904b1f3f5

# Not sure this is worth the trouble to preserve the full history, going to table it for now

################################################################################
# Initial Setup
################################################################################

# Run from top level of git repo

# Add remote
git remote add -f nanodbc-upstream https://github.com/lexicalunit/nanodbc.git
git checkout -b upstream/nanodbc nanodbc-upstream/master

# Track all changes to nanodbc.h
git checkout -b merging/nanodbc4 nanodbc-upstream/master

# Filter only files we are interested in and rewrite commit messages to have '[nanodbc] ' prepended.
git filter-branch -f --index-filter 'git rm --cached -qr --ignore-unmatch -- . && git reset -q $GIT_COMMIT -- picodbc.* nanodbc.* src/ nanodbc/ --prune-empty' --msg-filter '/bin/echo -n "[nanobc] ";cat' 

# split off subdir of tracking branch into separate branch
#git subtree split -q --squash --prefix=src --annotate="[nanodbc] " --rejoin -b merging/nanodbc-src
#git subtree split -q --squash --prefix=nanodbc --annotate="[nanodbc] " --rejoin -b merging/nanodbc-nanodbc

# add separate branch as subdirectory on master.
git checkout master
git subtree add --prefix=src/nanodbc merging/nanodbc3

################################################################################
# Updating
################################################################################

# switch back to tracking branch, fetch & rebase.
git checkout upstream/nanodbc
git pull nanodbc-upstream/master

# update the separate branch with changes from upstream
git subtree split -q --prefix=nanodbc --annotate="[nanodbc] " --rejoin -b merging/nanodbc3

# switch back to master and use subtree merge to update the subdirectory
git checkout master
git subtree merge -q --prefix=src/nanodbc merging/nanodbc3
