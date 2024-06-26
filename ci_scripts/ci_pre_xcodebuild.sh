#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Dashboard42
#
#  Created by Marc MOSCA on 06/05/2024.
#  

cp ./Template.plist "$CI_PRIMARY_REPOSITORY_PATH/$CI_XCODE_SCHEME/Api.plist"

sed "s|TMP_API_CLIENT_ID|$API_CLIENT_ID|g" "$CI_PRIMARY_REPOSITORY_PATH/$CI_XCODE_SCHEME/Api.plist"
sed "s|TMP_API_SECRET_ID|$API_SECRET_ID|g" "$CI_PRIMARY_REPOSITORY_PATH/$CI_XCODE_SCHEME/Api.plist"
sed "s|TMP_API_REDIRECT_URI|$API_REDIRECT_URI|g" "$CI_PRIMARY_REPOSITORY_PATH/$CI_XCODE_SCHEME/Api.plist"
