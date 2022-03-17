# AWS Metadata Bootstrap

## Synopsis
A small script to generate a metadata report when launching a Linux AWS EC2 instance

## Implementation Details
The script first tries to determine the operating system in order to set the package manager.  Once the package manager is found, it attempts to install the dependencies for the report.  From there, it starts to generate an HTML report using the metadata extracted from the AWS CLI V2 API.

## References
* https://github.com/ACloudGuru-Resources/course-aws-certified-solutions-architect-associate/blob/main/lab/ec2-instance-bootstrapping/webserver-02.sh

