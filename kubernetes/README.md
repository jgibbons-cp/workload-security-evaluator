To use the tool with Kubernetes rather than docker compose. 

1) Configure environment variables  
  
- In ```env.sh``` change <API_KEY> to an [API key](https://app.datadoghq.com/organization-settings/api-keys)  
- In  ```env.sh``` change <TAG> to the tag you want to use for the [Atomic Red Team container](https://atomicredteam.io/) 
For example, <DOCKER_ACCOUNT>/<TAG_NAME>:<TAG_VERSION>  
  
2) If you need to build the container  
  - Login to your registry so you can push  
  - Execute ```bash <REPO_ROOT>/docker/create_docker_image.sh```  
  
3) To configure Atomic Red Team tests and run the Datadog agent execute ```bash setup.sh```  
  
4) After the operator and agents are running, you can run the tests manually by execing into the atomic-red-team 
container:  
  
```kubectl exec -it atomic-red-team -- pwsh```  or exit and use ```run_tests.sh``` to run some base tests.  NOTE:
if you run the tests manually, there are a few clean up commands in ```run_tests.sh``` if you run the tests
on the same container more than once.
  
5) To run base tests execute ```run_tests.sh``` To see how the tests map to Datadog rules see [here](https://github.com/DataDog/workload-security-evaluator?tab=readme-ov-file#test-against-real-world-threats)  
  
6) To clean up run ```teardown.sh```  
