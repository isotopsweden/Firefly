#!/bin/bash
echo Patch, minor or major?
read bumpType
pubspecFile="./pubspec.yaml"
version=$(grep "version" "$pubspecFile" | cut -d':' -f2-)
newVersion=0.4.0
echo Updated from $version to $newVersion