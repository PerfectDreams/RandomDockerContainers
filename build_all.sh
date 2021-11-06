for d in */ ; do
    cd $d
    echo $PWD
    image_name=${d%"/"}
    echo "Building ${image_name}..."
    
    docker build . --file Dockerfile --tag ${image_name} --label "runnumber=${GITHUB_RUN_ID}"
    
    IMAGE_ID=ghcr.io/${GITHUB_REPO_OWNER}/${image_name}
    # Change all uppercase to lowercase
    IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')
    # Strip git ref prefix from version
    VERSION=$(echo "$GITHUB_REF" | sed -e 's,.*/\(.*\),\1,')
    # Strip "v" prefix from tag name
    [[ "$GITHUB_REF" == "refs/tags/"* ]] && VERSION=$(echo $VERSION | sed -e 's/^v//')
    # Use Docker `latest` tag convention
    [ "$VERSION" == "main" ] && VERSION=latest
    echo IMAGE_ID=$IMAGE_ID
    echo VERSION=$VERSION
    docker tag ${image_name} $IMAGE_ID:$VERSION
    docker push $IMAGE_ID:$VERSION
 
    cd ..
done