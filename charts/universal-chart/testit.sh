#!/bin/sh -eu
dname=$(dirname $0)
tests="$dname/tests"
rm -rf --one-file-system $tests
mkdir -p $tests
echo "Testing defaults"
helm template test $dname > $tests/default.yaml
diff -u $dname/results/default.yaml $tests/default.yaml
echo "OK"
for i in $dname/samples/*
do
  echo "Testing $i"
  n=$(basename $i)
  helm template test $dname --values $i |egrep -v '^ +helm.sh/chart:' > $tests/$n
  diff -u $dname/results/$n $tests/$n
  echo "OK"
done
