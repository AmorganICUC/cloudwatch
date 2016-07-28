#!/usr/bin/perl

use strict;
use warnings;
use Term::Menu;

#EC2 thresholds 
my $DiskReadBytes=60000;
my $NetworkOut=15000000;
my $DiskReadOps=100.0;
my $NetworkIn=10000000.0;
my $CPUUtilization=70;

#RDS thresholds
my $ReadLatency=0.0030000000000000001;
my $DatabaseConnections=400.0;


my $menu = new Term::Menu;
my $answer = $menu->menu(
      ec2    => ["Setup CloudWatch metrics and alarm for EC2", '1'],
      rds    => ["Setup CloudWatch metrics and alarm for RDS", '2'],
      exit    => ["Just exit", '3'],
);

if($answer =~ /ec2/mi) 
{
     ec2();
} 
	elsif($answer =~ /rds/mi) 
	{
	 rds();
	}
		elsif($answer =~ /exit/mi)
		{
		exit;
			}


sub ec2 {

print"Enter the EC2 InstanceID...e.g(i-8c1fdf18)\n";

chomp(my $alrminstanceid=<>);

system qq{aws cloudwatch put-metric-alarm --alarm-name $alrminstanceid-DiskReadBytes --alarm-description "Monitor network Disk activity " --metric-name DiskReadBytes --namespace AWS/EC2 --statistic Average --period 300 --threshold 60000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alrminstanceid-NetworkOut --alarm-description "Monitor network outgoing traffic threshold " --metric-name NetworkOut --namespace AWS/EC2 --statistic Average --period 300 --threshold 15000000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alrminstanceid-DiskReadOps --alarm-description "Monitor DiskReadOps threshold " --metric-name DiskReadOps --namespace AWS/EC2 --statistic Average --period 300 --threshold 100.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alrminstanceid-NetworkIn --alarm-description "Monitor network incoming traffic threshold " --metric-name NetworkIn --namespace AWS/EC2 --statistic Average --period 300 --threshold 10000000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alrminstanceid-CPUUtilization --alarm-description "Monitor EC2 servers cpu" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert --unit Percent};
sleep(2);
	print "Successfully Configured the following EC2 metrics:\n
	CPUUtilization\n
	NetworkIn\n
	DiskReadOps\n
	NetworkOut\n
	DiskReadBytes\n
";

}

sub rds {

print"Enter the RDS DBInstanceIdentifier...e.g(icuc-test-rds-1)\n";

chomp(my $dbidentifier=<>);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-ReadLatency --alarm-description "Monitor ReadLatency for RDS " --metric-name ReadLatency --namespace AWS/RDS --statistic Average --period 300 --threshold 0.0030000000000000001 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-DatabaseConnections --alarm-description "Monitor DatabaseConnections for RDS " --metric-name DatabaseConnections --namespace AWS/RDS --statistic Average --period 300 --threshold 400.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-NetworkTransmitThroughput --alarm-description "Monitor NetworkTransmitThroughput for RDS " --metric-name NetworkTransmitThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold 400.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-WriteThroughput --alarm-description "Monitor WriteThroughput for RDS " --metric-name WriteThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold 15000000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-ReadIOPS --alarm-description "Monitor ReadIOPS for RDS " --metric-name ReadIOPS --namespace AWS/RDS --statistic Average --period 300 --threshold 100.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 5 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-FreeStorageSpace --alarm-description "Monitor FreeStorageSpace for RDS " --metric-name FreeStorageSpace --namespace AWS/RDS --statistic Average --period 300 --threshold 10000000000.0 --comparison-operator LessThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 1 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-SwapUsage --alarm-description "Monitor SwapUsage for RDS " --metric-name SwapUsage --namespace AWS/RDS --statistic Average --period 300 --threshold 100000000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-FreeableMemory --alarm-description "Monitor FreeableMemory for RDS " --metric-name FreeableMemory --namespace AWS/RDS --statistic Average --period 300 --threshold 200000000.0 --comparison-operator LessThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-DiskQueueDepth --alarm-description "Monitor DiskQueueDepth for RDS " --metric-name DiskQueueDepth --namespace AWS/RDS --statistic Average --period 300 --threshold 2.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-WriteLatency --alarm-description "Monitor WriteLatency for RDS " --metric-name WriteLatency --namespace AWS/RDS --statistic Average --period 300 --threshold 2.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-NetworkReceiveThroughput --alarm-description "Monitor NetworkReceiveThroughput for RDS " --metric-name NetworkReceiveThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold 500000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $dbidentifier-WriteIOPS --alarm-description "Monitor WriteIOPS for RDS " --metric-name WriteIOPS --namespace AWS/RDS --statistic Average --period 300 --threshold 2000.0 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(2);

print "Successfully Configured the following EC2 metrics:\n
ReadLatency\n
DatabaseConnections\n
NetworkTransmitThroughput\n
WriteThroughput\n
ReadIOPS\n
FreeStorageSpace\n
SwapUsage\n
FreeableMemory\n
DiskQueueDepth\n
WriteLatency\n
NetworkReceiveThroughput\n
WriteIOPS\n
";
}
