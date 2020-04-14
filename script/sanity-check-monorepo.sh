set -e
set -x
grep includeBuild settings.gradle.kts | \
        sed -E 's/includeBuild\("([^"]+)"\)/\1/' | \
        xargs -t -n1 -I@ grep @ .meta || echo "Projects are missing in .meta"
