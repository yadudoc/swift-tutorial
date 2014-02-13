
# ensure that this script is being sourced

if [ ${BASH_VERSINFO[0]} -gt 2 -a "${BASH_SOURCE[0]}" = "${0}" ] ; then
  echo ERROR: script ${BASH_SOURCE[0]} must be executed as: source ${BASH_SOURCE[0]}
  exit 1
fi

# Add swift to PATHl

TUTSWIFT=/usr/local/swift/stable
PATHSWIFT=$(which swift 2>/dev/null)

if [ _$PATHSWIFT = _$TUTSWIFT/bin/swift ]; then
  echo using Swift from $TUTSWIFT,already in PATH
elif [ -x $TUTSWIFT/bin/swift ]; then
  echo Using Swift from $TUTSWIFT, and adding to PATH
  PATH=$TUTSWIFT/bin:$PATH
elif [ _$PATHSWIFT != _ ]; then
  echo Using $PATHSWIFT from PATH
else
  echo ERROR: $TUTSWIFT not found and no swift in PATH. Tutorial will not function.
  return
fi

echo Swift version is $(swift -version)
rm -f swift.log

# Setting scripts folder to the PATH env var.

TUTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ _$(which cleanup 2>/dev/null) != _$TUTDIR/bin/cleanup ]; then
  echo Adding $TUTDIR/bin:$TUTDIR/app: to front of PATH
  PATH=$TUTDIR/bin:$TUTDIR/app:$PATH
else
  echo Assuming $TUTDIR/bin:$TUTDIR/app: is already at front of PATH
fi

# Setting .swift files

if [ -e $HOME/.swift/swift.properties ]; then
  saveprop=$(mktemp $HOME/.swift/swift.properties.XXXX)
  echo Saving $HOME/.swift/swift.properties in $saveprop
  mv $HOME/.swift/swift.properties $saveprop
else
  mkdir -p $HOME/.swift
fi

cat >>$HOME/.swift/swift.properties <<END

# Properties for Swift Tutorial

sites.file=sites.xml
tc.file=apps

wrapperlog.always.transfer=true
sitedir.keep=true
file.gc.enabled=false
status.mode=provider

execution.retries=0
lazy.errors=false

use.wrapper.staging=false
use.provider.staging=true
provider.staging.pin.swiftfiles=false

END


HOST=$(hostname -f)

# Separating site specific configurations from the main setup script
if [[ $HOST == *yahoo-headnode* ]]
then
    source site_configs/occy.sh
fi

