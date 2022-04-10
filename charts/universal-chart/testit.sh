#!/bin/sh -eu
mkdir -p tests
echo "Testing defaults"
helm template test . > tests/default.yaml
diff -u results/default.yaml tests/default.yaml
echo "OK"
for i in samples/*
do
  echo "Testing $i"
  n=$(basename $i)
  helm template test . --values $i |egrep -v '^ +helm.sh/chart:' > tests/$n
  diff -u results/$n tests/$n
  echo "OK"
done
