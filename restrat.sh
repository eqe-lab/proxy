#!/bin/bash

# Run apachectl configtest and capture the return value
docker exec proxy /bin/bash -c "apachectl configtest" > /dev/null 2>&1
# Check the return value
if [ $? -ne 0 ]; then
  # If the return value is not 0 (which means failure), print the error message in red
  echo -e "\e[31mApache configuration test failed. See error details below:\e[0m"
  docker exec proxy /bin/bash -c "apachectl configtest"
else
  # If the return value is 0 (which means success), print success message in green
  echo -e "\e[32mApache configuration test passed. Restarting proxy...\e[0m"
  docker-compose restart proxy
  docker-compose logs -f proxy
fi
