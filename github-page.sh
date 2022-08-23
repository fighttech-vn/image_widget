#!/bin/bash
set -e

cd example/
flutter pub get
flutter build web --release --base-href="/image-widget/"

echo "Deploy Done !!!"