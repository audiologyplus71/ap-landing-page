git checkout gh-pages && \
git merge master && \
git subtree push --prefix build origin gh-pages && \
git checkout master
