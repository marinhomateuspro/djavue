#!/bin/bash
export COMPOSE_PROJECT_NAME=djavue_${CI_COMMIT_SHA}
docker-compose -f docker/compose/test.yml run djavue unittests.sh
exitcode=$?
docker-compose -f docker/compose/test.yml down
exit $exitcode
