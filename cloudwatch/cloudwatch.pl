#!/usr/bin/perl

###Script accepts 3 values to be run non-interactively 'cloudwatch.pl <rds> <dbidetifier> <alarm_name>' or 'cloudwatch.pl <ec2> <deviceid> <alarm_name>'
###See Readme file for more details

use strict;
use warnings;
use Term::Menu;

my($alarm_name,$alrminstanceid,$dbidentifier,$met);

#EC2 thresholds 
my $DiskReadBytes=60000;
my $NetworkOut=15000000;
my $DiskReadOps=100.0;
my $NetworkIn=10000000.0;
my $CPUUtilization=70;

#RDS thresholds
my $ReadLatency=0.0030000000000000001;
my $DatabaseConnections=400.0;
my $NetworkTransmitThroughput=400.0;
my $WriteThroughput=15000000.0;
my $ReadIOPS=100.0;
my $FreeStorageSpace=10000000000.0;
my $SwapUsage=100000000.0;
my $FreeableMemory=200000000.0;
my $DiskQueueDepth=2.0;
my $WriteLatency=2.0;
my $NetworkReceiveThroughput=500000.0;
my $WriteIOPS=2000.0;

my $num=$#ARGV + 1;

if($num == 3)

{
my $answers= $ARGV[0];

        if($answers eq "rds")
                {
               	$dbidentifier=$ARGV[1];
               	$alarm_name=$ARGV[2];
                rds();
                }
                        elsif($answers eq "ec2")

                        {
                        $alrminstanceid=$ARGV[1];
						$alarm_name=$ARGV[2];
						ec2();
                        }
				else
				{
				print"$0 accepts 3 values either (<rds> <dbidentifier> <alarm_name> or <ec2> <dbidentifier> <alarm_name>)\n";
				exit;
				}
}
        elsif($num != 3)
            	{

                goto MENU;

                        }

MENU:
my $menu = new Term::Menu;
my $answer = $menu->menu(
      ec2    => ["Setup CloudWatch metrics and alarm for EC2", '1'],
      rds    => ["Setup CloudWatch metrics and alarm for RDS", '2'],
      single => ["Setup single cloudwatch alarm for EC2 or RDS", '3'],
      exit    => ["Just exit", '4'],
);

if($answer =~ /ec2/mi) 
{
	print"Enter the EC2 InstanceID...e.g(i-8c1fdf18)\n";
	chomp($alrminstanceid=<>);
		print"Enter then EC2 Alarm name\n";
		chomp($alarm_name=<>);
			ec2();
} 
	elsif($answer =~ /rds/mi) 
	{
	print"Enter the RDS DBInstanceIdentifier...e.g(icuc-test-rds-1)\n";
	chomp(my $dbidentifier=<>);
		print"Enter the RDS Alarm name ";
		chomp($$alarm_name=<>);
			rds();
	}
	 elsif($answer =~ /single/mi)
		{
			print"Setup metric for ec2 or rds?\n";
			chomp($met=<>);
	                        if($met eq 'ec2')
				{
				print "Enter Device ID\n";
				chomp(my $deviceID=<>);
				print "Enter Alarm Name\n";
				chomp(my $alarmname=<>);
				print "Enter Alarm Description\n";
				chomp(my $description=<>);
				print "Enter metric name\n";
				chomp(my $metric=<>);
				print "Enter enter threshold\n";
				chomp(my $threshold=<>);
				print"Enter parameter i.e ..GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, GreaterThanOrEqualToThreshold..etc\n";
				chomp(my $parameter=<>);				

system qq{aws cloudwatch put-metric-alarm --alarm-name $alarmname-$metric --alarm-description "$description" --metric-name $metric --namespace AWS/EC2 --statistic Average --period 300 --threshold $threshold --comparison-operator $parameter  --dimensions "Name=InstanceId,Value=$deviceID" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};


					}
							elsif($met eq 'rds')
								{
								print "Enter DBidentifier\n";
				                                chomp(my $deviceID=<>);
                                				print "Enter Instance Name\n";
				                                chomp(my $alarmname=<>);
                                				print "Enter Alarm Description\n";
				                                chomp(my $description=<>);
                                				print "Enter metric name\n";
				                                chomp(my $metric=<>);
                                				print "Enter enter threshold\n";
				                                chomp(my $threshold=<>);
				                                print"Enter parameter i.e..GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, GreaterThanOrEqualToThreshold\n";
                                				chomp(my $parameter=<>);

system qq{aws cloudwatch put-metric-alarm --alarm-name $alarmname-$metric --alarm-description "$description" --metric-name $metric --namespace AWS/RDS --statistic Average --period 300 --threshold $threshold --comparison-operator $parameter  --dimensions "Name=DBInstanceIdentifier,Value=$deviceID" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};

sleep(2);
print "Operation was successfully..." if $? == 0;
						
									}
			
			
	
			}
		elsif($answer =~ /exit/mi)
		{
		exit;
			}


sub ec2 {
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-DiskReadBytes --alarm-description "Monitor network Disk activity " --metric-name DiskReadBytes --namespace AWS/EC2 --statistic Average --period 300 --threshold $DiskReadBytes --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-NetworkOut --alarm-description "Monitor network outgoing traffic threshold " --metric-name NetworkOut --namespace AWS/EC2 --statistic Average --period 300 --threshold $NetworkOut --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-DiskReadOps --alarm-description "Monitor DiskReadOps threshold " --metric-name DiskReadOps --namespace AWS/EC2 --statistic Average --period 300 --threshold $DiskReadOps --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-NetworkIn --alarm-description "Monitor network incoming traffic threshold " --metric-name NetworkIn --namespace AWS/EC2 --statistic Average --period 300 --threshold $NetworkIn --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-CPUUtilization --alarm-description "Monitor EC2 servers cpu" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold $CPUUtilization --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=$alrminstanceid" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert --unit Percent};
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



system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-ReadLatency --alarm-description "Monitor ReadLatency for RDS " --metric-name ReadLatency --namespace AWS/RDS --statistic Average --period 300 --threshold $ReadLatency --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-DatabaseConnections --alarm-description "Monitor DatabaseConnections for RDS " --metric-name DatabaseConnections --namespace AWS/RDS --statistic Average --period 300 --threshold $DatabaseConnections --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-NetworkTransmitThroughput --alarm-description "Monitor NetworkTransmitThroughput for RDS " --metric-name NetworkTransmitThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold $NetworkTransmitThroughput --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-WriteThroughput --alarm-description "Monitor WriteThroughput for RDS " --metric-name WriteThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold  $WriteThroughput --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-ReadIOPS --alarm-description "Monitor ReadIOPS for RDS " --metric-name ReadIOPS --namespace AWS/RDS --statistic Average --period 300 --threshold $ReadIOPS --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 5 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-FreeStorageSpace --alarm-description "Monitor FreeStorageSpace for RDS " --metric-name FreeStorageSpace --namespace AWS/RDS --statistic Average --period 300 --threshold $FreeStorageSpace --comparison-operator LessThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 1 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-SwapUsage --alarm-description "Monitor SwapUsage for RDS " --metric-name SwapUsage --namespace AWS/RDS --statistic Average --period 300 --threshold $SwapUsage --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-FreeableMemory --alarm-description "Monitor FreeableMemory for RDS " --metric-name FreeableMemory --namespace AWS/RDS --statistic Average --period 300 --threshold $FreeableMemory --comparison-operator LessThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-DiskQueueDepth --alarm-description "Monitor DiskQueueDepth for RDS " --metric-name DiskQueueDepth --namespace AWS/RDS --statistic Average --period 300 --threshold $DiskQueueDepth --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-WriteLatency --alarm-description "Monitor WriteLatency for RDS " --metric-name WriteLatency --namespace AWS/RDS --statistic Average --period 300 --threshold $WriteLatency --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-NetworkReceiveThroughput --alarm-description "Monitor NetworkReceiveThroughput for RDS " --metric-name NetworkReceiveThroughput --namespace AWS/RDS --statistic Average --period 300 --threshold $NetworkReceiveThroughput --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
sleep(5);
system qq{aws cloudwatch put-metric-alarm --alarm-name $alarm_name-WriteIOPS --alarm-description "Monitor WriteIOPS for RDS " --metric-name WriteIOPS --namespace AWS/RDS --statistic Average --period 300 --threshold $WriteIOPS --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=DBInstanceIdentifier,Value=$dbidentifier" --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:484505395026:TechSupport_Alert};
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
