#! /bin/bash

set -eu -o pipefail

CHANNEL="${1:-}"
if [ -z "$CHANNEL" ]; then
  CHANNEL="nightly"
fi

VERSION="${2:-}"
if [ -z "$VERSION" ]; then
  release=`curl "https://app.gitbutler.com/api/downloads?limit=1&channel=$CHANNEL" | jq .[0]`
  VERSION=`jq -r .version <<< "$release"`
else
  release=`curl "https://app.gitbutler.com/api/downloads?limit=1&channel=$CHANNEL&version=$VERSION" | jq .[0]`
fi

deb_download_url=`jq -r '.builds.[] | select( .os == "linux" and .arch == "x86_64" and (.url | test(".deb$")) ) | .url' <<< "$release"`

tmpdir=`mktemp -d`

echo "Downloading GitButler $CHANNEL $VERSION into $tmpdir"

curl -fsSLo "$tmpdir/gitbutler.deb" "$deb_download_url"
checksum=`sha256sum "$tmpdir/gitbutler.deb" | cut -d " " -f 1`

curl -fsSLo "$tmpdir/LICENSE.md" "https://raw.githubusercontent.com/gitbutlerapp/gitbutler/refs/heads/master/LICENSE.md"

echo 'pkgname=gitbutler-bin
provides=(${pkgname//-bin/""})
conflicts=(${pkgname//-bin/""})
pkgver=<VERSION_NUMBER>
pkgrel=1
pkgdesc="Version control client, backed by Git, powered by Tauri/Rust/Svelte"
arch=("x86_64")
url="https://gitbutler.com/"
depends=("libayatana-appindicator" "webkit2gtk-4.1" "gtk3")
license=("LicenseRef-FSL-1.1-MIT")
source=("gitbutler.deb"
        "LICENSE.md")
sha256sums=("<SHA256_SUM>"
            "2a3154bf44e0b219014291b96249082f3305844a1d73796741468c8128c2829e")

package() {
	bsdtar -xf "$srcdir/data.tar.gz" -C "$pkgdir"
	install -Dm644 LICENSE.md "$pkgdir/usr/share/licenses/$pkgname/LICENSE.md"
}
' > "$tmpdir/PKGBUILD"

sed -i -e "s/<VERSION_NUMBER>/$VERSION/" -e "s/<SHA256_SUM>/$checksum/" "$tmpdir/PKGBUILD"

cd "$tmpdir"
makepkg -si
