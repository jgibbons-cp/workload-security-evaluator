To use the tool with docker rather than docker compose.  
  
1) Configure environment variables  
  
- In ```env.sh``` change <API_KEY> to an [API key](https://app.datadoghq.com/organization-settings/api-keys)  
- In  ```env.sh``` change <TAG> to the tag you want to use for the [Atomic Red Team container](https://atomicredteam.io/) 
For example, <DOCKER_ACCOUNT>/<TAG_NAME>:<TAG_VERSION>  
  
2) If you need to build the container  
  - Login to your registry so you can push  
  - Execute ```create_docker_image.sh```  
  
3) To configure Atomic Red Team tests and run the Datadog agent execute ```bash setup.sh```  
  
4) This will drop you into ```powershell``` inside the atomic_red_team container.  You can run the tests manually
here, or exit and use ```run_tests.sh``` to run some base tests.  
  
5) To run base tests execute ```run_tests.sh```  