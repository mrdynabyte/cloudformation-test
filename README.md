# ElasticSearch CLI - Vectorized.io DevOps Test

## Requirements:

    - Python 3.7
    - AWS Access Key
    - AWS Secret Access Key

## Installation

Run `sh install.sh` on your Linux Machine. That wil install the tool's requirements to properly function. 

After the installation you will be required yo enter your: 

- **AWS Access Key**
- **AWS Secret Access Key**
- The default region where you want to work on: **us-east-1**
- The format to handle the responses of the librarty: Use **JSON** as default

As in the following example: 

```                       
AWS Access Key ID [None]: XXXXXXXXXXXXXXXXXXXX
AWS Secret Access Key [None]: abcdefghijklmnropqrstuvwxyz1652839509170
Default region name [None]: us-east-1
Default output format [None]: JSON
```

Once you enter that information the script will be ready for use.

## Usage

`./elasticsearch-cli [deploy | destroy | status | help]`.

Available options:

`-h` Show help menu
`deploy` Initiate the stack deployment using default CloudFormation template
`destroy` Destroy the current available stack
`status` Get the current status of the deployment


## Discussion

#### Security

This is not a secure environment. Please don't use it in production.

Improvements to be made:

- Move the ElasticSearch nodes into a private subnet and so each instance are not directly reachable from the internet.
- Add a NAT gateway that allow us to map incoming internet traffic to our private node(s), thus, avoiding to have a public IP exposed for our node(s) container instance .
- Limit incoming and outgoing traffic on the Security Group to only allow trafic from HTTPS sources on port 443.
- Add extra security layer at the subnet level using ACL because the Security Group by itself does not allow DENY rules. On this layer we will not only limit traffic from HTTPS with 443 but also deny another type of connections to our network.

#### Testing

This project does not contain any kind of tests. Nevertheless using the python default testing framework `pytest` it is easy to design a suite of tests for this CLI tool. Also, with the support of the AWS SDK `boto3` we can easily assert the results of the tests to validate the behavior.

#### Further work

- **What would need to be done to support multi-node (cluster) deployments?**: The stack can be enhanced in three levels:
    - Application level: The less desirable scenario: This means we can have multiple nodes in a single container but that would'nt be an actual improvement.
    - Container level: The efficient scenario: We can add as many containers as we like that belong to the same ElasticSearch nodes network. Extra configuration would be needed on each node in order to discover and link containers between them (by the ElasticSearch process, not by the containers which Fargate already provides) so the icoming load is propely distributed among them. 
    - Task level: The ideal scenario: If we limit the main task to a certain amount of elasticsearch containers, that means we can scale up our ECS cluster to have as many mirrored tasks instances as we like so the incoming load is properly distributed among our tasks instances and inner containers. To achieve this we would also need a load balancer in front of our ECS to handle the incoming network traffic and redirect them into our tasks' ENIs and nodes' containers.

- **If you had more time, what would you do to further simplify the deploymentprocess?**: 
    - I would have added the Policies and Roles to be placed and available by default for all regions in our cloud. Thus, allowing me to only focus the template content on the actual resources that I needed for the deployment. In terms of code in the CLI, I think it's good but it can handle better the client exceptions.

- **What were the main obstacles you had to overcome while working on your solution?**: 
    - To find a starting point to be able to test and the resources interdependency. Mostly the AWS learning curve, not the concepts themselves. When I started I literally had no idea how to make a cloud infrastructure deployment. I had never used Terraform or Cloudformation to build a cloud infrastructure. Not even the AWS console. I read a lot about Terraform that it is somehow *better* than CloudFormation, but truth be told, I rather prefer CloudFormation because it not only interacts directly with the AWS resources and I could only focus on debugging *its* problems. If I would have chosen Terraform I would have had 2 problems: The AWS problems, and how to overcome them using TerraForm.

    - The IAM policies and roles were also a problem to solve because I think it's the more specific type of resource you can use. It toke me a lot of time to understand how to manage them and how to apply them on the resources I needed them to make the resources work.

    - And last but not least: The fact that elasticsearch **latest** tag **WAS NOT AVAILABLE** on the Docker Hub registry. And the Major problem was that it wouldn't let the container to be created because **IT WOULD NOT FIND THE TAG**. (I did not specify any kind of tag at first.)

- **Performance considerations, process isolation & resource limits.**: 
    - I designed this deployment to be used with Fargate. If I would have chosen ECS with a EC2 instance, we would have had to manage more things instead of only the ElasticSearch containers.
    - As mentioned above, the containers can be isolated in a private network so they are not reachable directly from internet.
    - Resource limits: We can setup each node's instance to its minimum (1GB Process / 8GB Memory) and scale up the ECS cluster in the task level. Thus assuring us minimum usage of the CPU/Memory consumption which on Fargate costs are calculated. This anyhow depends on the incoming load available.

- **Extras**:
    - I added network logs for the VPC so I could know wether the traffic was getting in or out of the VPC
    - I added logs for each running task instance.
    - Both can be found on CloudWatch/LogGroups

