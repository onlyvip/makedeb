# Maintainer: Hunter Wittenborn: <hunter@hunterwittenborn.com>
_release_type=beta

# Used to obtain folder names for local repository
_gitdir=$(git rev-parse --show-toplevel)
_foldername=$(basename "${_gitdir}")

pkgname=makedeb-beta
pkgver={pkgver}
pkgrel=1
pkgdesc="The modern packaging tool for Debian archives (beta release)"
arch=('any')
license=('GPL3')
depends=('bash' 'binutils' 'tar' 'file' 'lsb-release' 'python3' 'python3-apt' 'asciidoctor' 'makedeb-makepkg-beta')
optdepends=('r!apt')
conflicts=('makedeb' 'makedeb-alpha')
provides=('makedeb')
url="https://github.com/makedeb/makedeb"

source=("git+file://${_gitdir}")
sha256sums=('SKIP')

prepare() {
  # Set package version and release type
  sed -i "s|makedeb_package_version=.*|makedeb_package_version=${pkgver}-${pkgrel}|" "${_foldername}/src/makedeb.sh"
  sed -i "s|makedeb_release_type=.*|makedeb_release_type=${_release_type}|" "${_foldername}/src/makedeb.sh"

  # Remove prebuild commands
  sed -i 's|.*# REMOVE AT PACKAGING||g' "${_foldername}/src/makedeb.sh"
}

package() {
  # Create single file for makedeb
  mkdir -p "${pkgdir}/usr/bin"
  cd "${srcdir}/${_foldername}"

  # Add bash shebang
  echo '#!/usr/bin/env bash' > "${pkgdir}/usr/bin/makedeb"

  # Copy functions
  for i in $(find "src/functions/"); do
    if ! [[ -d "${i}" ]]; then
      cat "${i}" >> "${pkgdir}/usr/bin/makedeb"
    fi
  done

  cat "src/makedeb.sh" >> "${pkgdir}/usr/bin/makedeb"
  chmod 555 "${pkgdir}/usr/bin/makedeb"
  
  # Copy over extra utilities.
  cd ./src/utils/
  find ./ -type f -exec install -Dm 755 '{}' "${pkgdir}/usr/share/makedeb/utils/{}" \;
  cd ../../

  # Set up man pages
  SOURCE_DATE_EPOCH="$(git log -1 --pretty='%ct' man/makedeb.8.adoc)" \
    asciidoctor -b manpage man/makedeb.8.adoc \
                -o "${pkgdir}/usr/share/man/man8/makedeb.8"

  SOURCE_DATE_EPOCH="$(git log -1 --pretty='%ct' man/pkgbuild.5.adoc)" \
    asciidoctor -b manpage man/pkgbuild.5.adoc \
                -o "${pkgdir}/usr/share/man/man5/pkgbuild.5"
}
