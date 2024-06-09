#!/bin/bash

VERSION=""

# Obtener parámetros
while getopts v: flag
do
  case "${flag}" in
    v) VERSION=${OPTARG};;
  esac
done

# Obtener la etiqueta más alta y agregar v1.1.0 si no existe
git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=`git describe --abbrev=0 --tags 2>/dev/null`

if [[ $CURRENT_VERSION == '' ]]
then
  CURRENT_VERSION='v1.1.0'
fi
echo "Current Version: $CURRENT_VERSION"

# Reemplazar . con espacio para poder dividir en un array
CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

# Obtener las partes de la versión
VNUM1=${CURRENT_VERSION_PARTS[0]//v}  # Eliminar 'v' al inicio de la versión mayor
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}

# Incrementar la versión según el tipo especificado
if [[ $VERSION == 'major' ]]
then
  VNUM1=$((VNUM1+1))
  VNUM2=0
  VNUM3=0
elif [[ $VERSION == 'minor' ]]
then
  VNUM2=$((VNUM2+1))
  VNUM3=0
elif [[ $VERSION == 'patch' ]]
then
  VNUM3=$((VNUM3+1))
else
  echo "No version type (https://semver.org/) or incorrect type specified, try: -v [major, minor, patch]"
  exit 1
fi

# Crear nueva etiqueta
NEW_TAG="v$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

# Obtener el hash actual y verificar si ya tiene una etiqueta
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`

# Solo etiquetar si no hay una etiqueta ya
if [ -z "$NEEDS_TAG" ]; then
  echo "Tagged with $NEW_TAG"
  git tag $NEW_TAG
  git push --tags
  git push
else
  echo "Already a tag on this commit"
fi

echo ::set-output name=git-tag::$NEW_TAG

exit 0
