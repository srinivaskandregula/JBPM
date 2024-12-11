# jBPM Docker Image

This repository provides a Docker image for deploying JBoss jBPM (version 7.61.0.Final) along with a WildFly server (version 23.0.0.Final). The image is pre-configured with key components of the jBPM suite, including Business Central, KIE Server, jBPM Case Management showcase, and the jBPM Service repository.

## Components Included

The Docker image includes the following:

- **WildFly Server**  
- **Business Central**  
- **KIE Server**  
- **jBPM Case Management Showcase**  
- **jBPM Service Repository**

## Version Information

- **jBPM**: 7.61.0.Final  
- **WildFly Server**: 23.0.0.Final  

This image is designed to be easily extended, allowing you to add custom configurations as needed.

## How to Use

### Pull the Docker Image

To download the latest version of the image from Docker Hub, run:

```bash
docker pull srinivas42/jbpm-full-server-2024:latest
```

### Run a Container

To start a container from the image, use the following command:

```bash
docker run -p 8080:8080 -p 9990:9990 -d --name jbpm-workbench srinivas42/jbpm-full-server-2024:latest
```

This command will run the container in detached mode and map the necessary ports:

- Port `8080` for accessing Business Central
- Port `9990` for accessing the WildFly server's HA Console Management

### Accessing Business Central

Once the container is running, you can access the **jBPM Business Central** by navigating to the following URL:

```
http://localhost:8080/business-central
```

### Accessing the WildFly Server HA Console Management

To manage the WildFly server, you will need to create a user to access the HA Console Management interface. Follow the steps below:

1. **Access the running container**:

   ```bash
   docker exec -it <container_name_or_id> bash
   ```

2. **Navigate to the WildFly directory**:

   ```bash
   cd /opt/jbpm/standalone/bin
   ```

3. **Create a user for HA Console Management**:

   Run the script to create a new user:

   ```bash
   ./add-user.sh
   ```

   Follow the prompts to create the user credentials.

4. **Access the WildFly HA Console**:

   After creating the user, you can access the WildFly server's HA Console at:

   ```
   http://localhost:9990/console/index.html
   ```

### Customization

The image is designed to be flexible, so you can easily add your own configurations to suit your needs. You can mount additional configuration files or override environment variables as required.

## Notes

- Ensure that the necessary ports (8080 and 9990) are available and not being used by other services on your local machine.
- The image is built with the intention of providing a fully functional jBPM environment out of the box, but further customization may be required depending on your specific use case.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
