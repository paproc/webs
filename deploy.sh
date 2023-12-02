
cd /workspace

# set ASSETS_MD5SUM_URL_FOR_COMPARASION on github actions variables to vyfuk adress and /assets/assetsmd5.txt
owner=paproc

git fetch
commit=$(git log --pretty=format:'%H' -n 1 origin/master)
artefact=webs-$commit-npm-18.x
artefactid=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owner/webs/actions/artifacts \
| jq ".artifacts | .[] | select(.name==\"$artefact\") | .id")

#jq: error (at <stdin>:4): Cannot iterate over null (null)
if [ -z "$artefactid" ];
then
    exit 1;
fi
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  --output temp/assets.zip \
  https://api.github.com/repos/$owner/webs/actions/artifacts/$artefactid/zip

unzip temp/assets.zip -d temp/assets
git merge --ff-only
cp -r temp/assets/* www
rm -r temp/*
find www/*/assets/ -type f -exec md5sum {} + >> www/vyfuk/assets/assetsmd5.txt 