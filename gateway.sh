#!/bin/bash

# hack to initialize gradle
./gradlew tasks -q >>/dev/null 2>&1
# environment to publish to
action=$1
gatewayUrl=$2
gatewayUsername=$3
gatewayPassword=$4

projects=$(./gradlew getSubProjects -q --warning-mode none)
projectArr=($(echo $projects | tr ";" "\n"))
exclusions=$(./gradlew getExclusions -q --warning-mode none)
exclusionsArr=($(echo $exclusions | tr ";" "\n"))

RemoveExclusions() {
    for i in "${!exclusions[@]}"; do
        find ./ -type f -iname "${exclusions[$i]}.yml" -delete
    done
}

BuildEnv() {
    for i in "${!projectArr[@]}"; do
        if [[ "${projectArr[$i]}" == *"-env"* ]] || [[ "${projectArr[$i]}" == "common" ]]; then
            # check versions and see if there any updates... but for now build and publish
            echo "Building Environment Bundle: ${projectArr[$i]}"
            ./gradlew ${projectArr[$i]}:build-environment-bundle -q
        fi
    done
}

BuildServices() {
    for i in "${!projectArr[@]}"; do
        if [[ "${projectArr[$i]}" != *"-env"* ]] && [[ "${projectArr[$i]}" != "common" ]]; then
            echo "Building Service Bundle: ${projectArr[$i]}"
            ./gradlew ${projectArr[$i]}:build -q
            version=$(GetVersion ${projectArr[$i]})
            # remove gw7 file
            rm ${projectArr[$i]}/build/gateway/${projectArr[$i]}-${version}.gw7
        fi
    done
}

Package() {
    for i in "${!projectArr[@]}"; do
        # check versions and see if there any updates... but for now build and publish
        version=$(GetVersion ${projectArr[$i]})
        type=$(GetType ${projectArr[$i]})
        echo "Packaging: ${projectArr[$i]}-${type}-${version}"
        tar -zcvf ./packages/${projectArr[$i]}-${type}-${version}.tar.gz ./${projectArr[$i]}/build/gateway/bundle >/dev/null 2>&1
    done
}

Deploy() {
    for i in "${!projectArr[@]}"; do
        ./gradlew ${projectArr[$i]}:import-bundle -PgatewayURL=$1 -PgatewayUsername=$2 -PgatewayPassword=$3 -q
    done
}

PerformAction() {
    if [[ "${1}" == "build" ]]; then
        RemoveExclusions
        BuildEnv
        BuildServices
        exit 0
    elif [[ "${1}" == "package" ]]; then
        mkdir -p packages
        Package
        ls ./packages
        exit 0
    elif [[ "${1}" == "deploy" ]]; then
        Deploy $environment $gatewayUrl $gatewayUsername $gatewayPassword
        exit 0
    else
        echo "This script requires 1 argument build|package|deploy"
        echo "Deploy takes in 3 additional arguments gatewayUrl, gatewayUsername, gatewayPassword"
        exit 1
    fi
}

GetVersion() {
    version=$(./gradlew $1:getCurrentVersion -q)
    echo $version
}

GetType() {
    type=$(./gradlew $1:getProjectType -q)
    echo $type
}

PerformAction $action
