#!/bin/bash

 

# Replace these variables with your GitHub username and access token
GITHUB_USERNAME="PrashanthKanuka"
GITHUB_TOKEN="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"
#GITHUB_TOKEN=${Github_Repo.PrashanthKanuka}
REPO_NAME="New-updated31"

 

# Check if the repository exists
check_repo_existence() {
    repo_url="https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME"
    response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$repo_url")
    if [[ "$response" == *"Not Found"* ]]; then
        return 1  # Repository does not exist
    else
        return 0  # Repository exists
    fi
}

 

# Create the repository
create_github_repository() {
    curl -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/user/repos" -d "{\"name\":\"$REPO_NAME\", \"private\": true}"
}

 

# Main script
check_repo_existence
if [ $? -eq 1 ]; then
    echo "Repository does not exist. Creating the repository..."
    create_github_repository
    echo "Repository created successfully!"
else
    echo "Repository already exists."
fi

 

# Clone the repository locally
git clone "git clone https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
cd "$REPO_NAME"

 

# Create a new file and commit it to the main branch
echo "Hello World" > hello.txt
git add hello.txt
git commit -m "Initial commit"
git push origin main

 

# Create a new feature branch from the main branch
FEATURE_BRANCH="feature"
git checkout -b "$FEATURE_BRANCH"

 

# Make changes to the file and commit to the feature branch
echo "Feature update" >> hello.txt
git add hello.txt
git commit -m "Feature update"
git push origin "$FEATURE_BRANCH"

 

# Create a pull request
curl -X POST -H "Authorization: token $GITHUB_TOKEN" -d '{"title":"Feature Update", "body":"Please review this feature update.", "head":"'$FEATURE_BRANCH'", "base":"main"}' "https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME/pulls"
