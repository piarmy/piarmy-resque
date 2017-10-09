#!/bin/bash
# (sh /home/pi/images/piarmy-resque-stack/scaler.sh &) > /dev/null 2>&1

clear

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

scriptSleep=5

resqueContainer="resque_piarmy-resque"
lambdaContainer="piarmy_lambda"
resqueEndpoint="http://piarmy01:3000/json-api/info"

thresholdMax=10
thresholdMin=0

timestamp() {
  date +"%T"
}

while true
do
  # Check if elasticsearch service is running, if so push stats
  if [[ $(docker service ls | grep ${resqueContainer}) ]]; then
    date=`date`
    pendingJobs=$(curl -s $resqueEndpoint | jq -r '.pending')
    currentReplicaCount=$(docker service inspect --format='{{.Spec.Mode.Replicated.Replicas}}' $lambdaContainer)

    if [[ $pendingJobs == 0 ]]; then
      echo "${date}: No pending jobs: ${resqueContainer}, ${lambdaContainer} replica count: ${currentReplicaCount}"
      echo ""

      if [[ $currentReplicaCount -gt 1 ]]; then
        echo "  ** Scaling DOWN **"
        docker service scale ${lambdaContainer}=1
        echo "  **"
        echo ""
      fi

      sleep $scriptSleep
    else
      threshold=$((pendingJobs / currentReplicaCount))

      echo $date
      echo "  Pending Jobs:          ${pendingJobs}"
      echo "  Current Replica Count: ${currentReplicaCount}"
      echo "  Threshold:             ${threshold}"
      echo ""

      if [[ $threshold -ge $thresholdMax ]] && [[ $currentReplicaCount -lt 5 ]]; then
        newScale=$((currentReplicaCount + 1))
        echo "  ** Scaling UP: **"
        docker service scale ${lambdaContainer}=${newScale}
        echo "  **"
        echo ""
      else
        if [[ $threshold -le $thresholdMin ]] && [[ $currentReplicaCount -gt 1 ]]; then
          newScale=$((currentReplicaCount - 1))
          echo "  ** Scaling DOWN **"
          docker service scale ${lambdaContainer}=${newScale}
          echo "  **"
          echo ""
        else
          echo "${date}: ${pendingJobs} pending jobs in ${resqueContainer} queue. Theshold is fine: ${threshold}"
          echo ""
        fi
      fi

      sleep $scriptSleep
    fi
  fi
done

