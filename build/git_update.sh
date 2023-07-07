#!bin/bash

VERSION=""

# get parameters
while getopts v: flag
do 
    case "${flag}" in 
        v) VERSION=${OPTARG};;
    esac
done

# get last tag 
git fetch --prune  --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

echo "CURRENT_VERSION: $CURRENT_VERSION"

if [[ "$CURRENT_VERSION" == "" ]]; then
    echo "CURRENT_VERSION is empty"
    CURRENT_VERSION='v0.1.0'
else
    echo "CURRENT_VERSION: $CURRENT_VERSION"
fi

# replace . with  space 
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

# get number parts
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}

if [[ $VERSION == 'major' ]]
then
    VNUM1=v$((VNUM1+1))
elif [[ $VERSION == 'minor' ]]
then    
    VNUM2=$((VNUM2+1))
elif [[ $VERSION == 'patch' ]]
then 
    VNUM3=$((VNUM3+1))
else 
    echo "No version type or incorrect type"
    exit 1
fi

NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

# get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git descrobe --contains $GIT_COMMIT 2>/dev/null`
echo "Premission Denied ???"

# only tag if no tag already
if [ -z "$NEEDS_TAG" ]; then
    echo "Tagged with $NEW_TAG"
    git tag $NEW_TAG
    git push --tags
    git push
else 
    echo "Already a tag on this"
fi

echo ::set-output name=git-tag::$NEW_TAG

exit 0 



