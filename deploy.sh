# Get absolute path of the script.
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )

# Get the current branch name.
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if the repo is on the master branch.
# If NOT, then display a warning message and abort.
if [[ $BRANCH != "master" ]] ; then
	echo "You must be on branch 'master' to deploy."
	exit
fi

# Run Gulp task.
echo -e "Building via Gulp...\n"
gulp

# Run fingerprint logic
echo -e "Making build fingerprint...\n"

# Capture the current date and time.
dt=`date '+%d/%m/%Y @ %H:%M:%S'`

# Modify the build date js file.
echo "(function deployDate() {console.log('$dt');})()" > "$PARENT_PATH/js/fingerprint.js"


# Remove build directory.
rm -rf build

# Copy files to build.
mkdir build
cp index.html build/
cp favicon.ico build/
cp -r ./css ./build
cp -r ./img ./build
cp -r ./vendor ./build
cp -r ./js ./build

# Commit changes.
echo -e "Committing pre-deploy changes...\n"
git add -A && \
git commit -m "Pre-deploy changes @ $dt"

# Deploy site to gh-pages.
echo -e "Deploying site to gh-pages...\n"
git checkout gh-pages && \
git merge master && \
git push origin --delete gh-pages && \
git subtree push --prefix build origin gh-pages && \
git checkout master

echo -e "Deploy done...\n"
