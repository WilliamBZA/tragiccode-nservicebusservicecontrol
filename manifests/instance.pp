# @summary Manages Service Control Instances.
#
# @param ensure
#   Specifies whether the instance should exist.
#
# @param instance_name
#   Specify the name of the ServiceControl Instance (title).
#
# @param install_path
#   Specify the directory to use for this ServiceControl Instance.
#
# @param db_path
#   Specify the directory that will contain the nservicebusservicecontrol database for this ServiceControl Instance.
#
# @param db_index_storage_path
#   Specify the path for the indexes on disk.
#
# @param db_logs_path
#   Specify the path for the Esent logs on disk.
#
# @param log_path
#   Specify the directory to use for this ServiceControl Logs.
#
# @param instance_log_level
#   Specify the level of logging that should be used in ServiceControl logs.
#
# @param host_name
#   Specify the hostname to use in the URLACL.
#
# @param port
#   Specify the port number to listen on. If this is the only ServiceControl instance then 33333 is recommended.
#
# @param database_maintenance_port
#   Specify the database maintenance port number to listen on. If this is the only ServiceControl instance then 33334 is recommended.
#
# @param expose_ravendb
#   Specify if the embedded ravendb database should be accessible outside of maintenance mode.
#
# @param ravendb_log_level
#   Specify the level of logging that should be used in ravendb logs.
#
# @param error_queue
#   Specify ErrorQueue name to consume messages from.
#
# @param audit_queue
#   Specify AuditQueue name to consume messages from.
#
# @param error_log_queue
#   Specify Queue name to forward error messages to.
#
# @param audit_log_queue
#   Specify Queue name to forward eudit messages to.
#
# @param transport
#   Specify the NServiceBus Transport to use.
#
# @param display_name
#   Specify the Windows Service Display name. If unspecified the instance name will be used.
#
# @param connection_string
#   Specify the connection string to use to connect to the queuing system.
#
# @param description
#   Specify the description to use on the Windows Service for this instance.
#
# @param forward_audit_messages
#   Specify if audit messages are forwarded to the queue specified by AuditLogQueue.
#
# @param forward_error_messages
#   Specify if audit messages are forwarded to the queue specified by ErrorLogQueue.
#
# @param service_account
#   The Account to run the Windows service.
#
# @param service_account_password
#   The password for the ServiceAccount.
#
# @param service_restart_on_config_change
#   Specify if the servicecontrol instance's windows service should be restarted to pick up changes to its configuration file.
#
# @param audit_retention_period
#   Specify the period to keep an audit message before it is deleted.
#
# @param error_retention_period
#   Specify thd grace period that faulted messages are kept before they are deleted.
#
# @param event_retention_period
#   Specifies the period to keep event logs before they are deleted.
#
# @param expiration_process_timer_in_seconds
#   Specifies the number of seconds to wait between checking for expired messages.
#
# @param expiration_process_batch_size
#   Specifies the batch size to use when checking for expired messages.
#
# @param hours_to_keep_messages_before_expiring
#   Specifies the number of hours to keep a message before it is deleted.
#
# @param maximum_message_throughput_per_second
#   Specifies the maximum throughput of messages ServiceControl will handle per second and is necessary to avoid overloading the underlying messages database.
#
# @param max_body_size_to_store
#   Specifies the upper limit on body size to be configured.
#
# @param http_default_connection_limit
#   Specifies the maximum number of concurrent connections allowed by ServiceControl.
#
# @param heartbeat_grace_period
#   Specifies the period that defines whether an endpoint is considered alive or not since the last received heartbeat.
#
# @param service_manage
#   Specifies whether or not to manage the desired state of the windows service for this instance.
#
# @param skip_queue_creation
#   Normally an instance will attempt to create the queues that it uses. If this flag is set, queue creation will be skipped.
#
define nservicebusservicecontrol::instance (
  Enum['present', 'absent'] $ensure,
  String $instance_name                                    = $title,
  Stdlib::Absolutepath $install_path                       = "C:\\Program Files (x86)\\Particular Software\\${instance_name}",
  Stdlib::Absolutepath $db_path                            = "C:\\ProgramData\\Particular\\ServiceControl\\${instance_name}\\DB",
  Stdlib::Absolutepath $log_path                           = "C:\\ProgramData\\Particular\\ServiceControl\\${instance_name}\\Logs",
  Stdlib::Absolutepath $db_index_storage_path              = "${db_path}\\Indexes",
  Stdlib::Absolutepath $db_logs_path                       = "${db_path}\\logs",
  Nservicebusservicecontrol::Log_level $instance_log_level = 'Warn',
  Stdlib::Fqdn $host_name                                  = 'localhost',
  Stdlib::Port $port                                       = 33333,
  Stdlib::Port $database_maintenance_port                  = 33334,
  Boolean $expose_ravendb                                  = false,
  Nservicebusservicecontrol::Log_level $ravendb_log_level  = 'Warn',
  String $error_queue                                      = 'error',
  String $audit_queue                                      = 'audit',
  Optional[String] $error_log_queue                        = 'error.log',
  Optional[String] $audit_log_queue                        = 'audit.log',
  Nservicebusservicecontrol::Transport $transport          = 'MSMQ',
  String $display_name                                     = $instance_name,
  Optional[String] $connection_string                      = undef,
  String $description                                      = 'A ServiceControl Instance',
  Boolean $forward_audit_messages                          = true, # change to false when https://github.com/Particular/ServiceControl/issues/1567 is resolved
  Boolean $forward_error_messages                          = false,
  String $service_account                                  = 'LocalSystem',
  Optional[String] $service_account_password               = undef,
  Boolean $service_restart_on_config_change                = true,
  String $audit_retention_period                           = '30.00:00:00',
  String $error_retention_period                           = '15.00:00:00',
  String $event_retention_period                           = '14.00:00:00',
  Integer $expiration_process_timer_in_seconds             = 600,
  Integer $expiration_process_batch_size                   = 65512,
  Integer $hours_to_keep_messages_before_expiring          = 720,
  Integer $maximum_message_throughput_per_second           = 350,
  Integer $max_body_size_to_store                          = 102400,
  Integer $http_default_connection_limit                   = 100,
  String $heartbeat_grace_period                           = '00:00:40',
  Boolean $service_manage                                  = true,
  Boolean $skip_queue_creation                             = false,
  Boolean $remove_db_on_delete                             = false,
  Boolean $remove_logs_on_delete                           = false,
  Boolean $automatic_instance_upgrades                     = true,
  ) {

  if $ensure == 'present' {

    if $transport == 'MSMQ' or $transport == 'AmazonSQS' {
      if $connection_string != undef {
        fail('Cannot provide connection_string when using the MSMQ transport')
      }
    }

    exec { "create-service-control-instance-${instance_name}":
      # I could also maybe look at the following to determine idempotence of create
      # 1.) Does a service exist with the name of the instance
      # 2.) Does the following folder exist $install_path
      command   => epp("${module_name}/create-instance.ps1.epp", {
        'instance_name'             => $instance_name,
        'install_path'              => $install_path,
        'db_path'                   => $db_path,
        'log_path'                  => $log_path,
        'host_name'                 => $host_name,
        'port'                      => $port,
        'database_maintenance_port' => $database_maintenance_port,
        'error_queue'               => $error_queue,
        'audit_queue'               => $audit_queue,
        'error_log_queue'           => $error_log_queue,
        'audit_log_queue'           => $audit_log_queue,
        'transport'                 => $transport,
        'display_name'              => $display_name,
        'connection_string'         => $connection_string,
        'description'               => $description,
        'forward_audit_messages'    => $forward_audit_messages,
        'forward_error_messages'    => $forward_error_messages,
        'service_account'           => $service_account,
        'service_account_password'  => $service_account_password,
        'audit_retention_period'    => $audit_retention_period,
        'error_retention_period'    => $error_retention_period,
        'skip_queue_creation'       => $skip_queue_creation,
      }),
      onlyif    => epp("${module_name}/query-instance.ps1.epp", {
        'instance_name' => $instance_name,
        }),
      logoutput => true,
      provider  => 'powershell',
    }

    if $automatic_instance_upgrades {
      exec { "automatic-instance-upgrade-${instance_name}":
        command   => epp("${module_name}/upgrade-instance.ps1.epp", {
          'instance_name' => $instance_name,
        }),
        onlyif    => epp("${module_name}/query-instance-upgrade.ps1.epp", {
          'instance_name' => $instance_name,
          'install_path'  => $install_path,
        }),
        logoutput => true,
        provider  => 'powershell',
        require   => Exec["create-service-control-instance-${instance_name}"],
      }
    }

    $_transport_type = $transport ? {
      'RabbitMQ - Conventional routing topology' => 'ServiceControl.Transports.RabbitMQ.RabbitMQConventionalRoutingTransportCustomization, ServiceControl.Transports.RabbitMQ',
      'SQL Server'                               => 'ServiceControl.Transports.SqlServer.SqlServerTransportCustomization, ServiceControl.Transports.SqlServer',
      'MSMQ'                                     => 'ServiceControl.Transports.Msmq.MsmqTransportCustomization, ServiceControl.Transports.Msmq',
      'Azure Storage Queue'                      => 'ServiceControl.Transports.ASQ.ASQTransportCustomization, ServiceControl.Transports.ASQ',
      'Azure Service Bus'                        => 'ServiceControl.Transports.ASBS.ASBSTransportCustomization, ServiceControl.Transports.ASBS',
      'AmazonSQS'                                => 'ServiceControl.Transports.SQS.SQSTransportCustomization, ServiceControl.Transports.SQS',
      # lint:ignore:140chars
      default                                    => fail("${transport} is not a known or valid transport that can be used with this module.  If this is a mistake please open a ticket on github."),
      # lint:endignore
    }

  file { "${install_path}\\ServiceControl.exe.config":
    ensure  => 'file',
    content => unix2dos(epp("${module_name}/ServiceControl.exe.config.epp", {
      'instance_log_level'                     => $instance_log_level,
      'db_path'                                => $db_path,
      'db_index_storage_path'                  => $db_index_storage_path,
      'db_logs_path'                           => $db_logs_path,
      'log_path'                               => $log_path,
      'host_name'                              => $host_name,
      'port'                                   => $port,
      'database_maintenance_port'              => $database_maintenance_port,
      'expose_ravendb'                         => $expose_ravendb,
      'ravendb_log_level'                      => $ravendb_log_level,
      'error_queue'                            => $error_queue,
      'audit_queue'                            => $audit_queue,
      'error_log_queue'                        => $error_log_queue,
      'audit_log_queue'                        => $audit_log_queue,
      '_transport_type'                        => $_transport_type,
      'connection_string'                      => $connection_string,
      'forward_audit_messages'                 => $forward_audit_messages,
      'forward_error_messages'                 => $forward_error_messages,
      'audit_retention_period'                 => $audit_retention_period,
      'error_retention_period'                 => $error_retention_period,
      'event_retention_period'                 => $event_retention_period,
      'expiration_process_timer_in_seconds'    => $expiration_process_timer_in_seconds,
      'expiration_process_batch_size'          => $expiration_process_batch_size,
      'hours_to_keep_messages_before_expiring' => $hours_to_keep_messages_before_expiring,
      'maximum_message_throughput_per_second'  => $maximum_message_throughput_per_second,
      'max_body_size_to_store'                 => $max_body_size_to_store,
      'http_default_connection_limit'          => $http_default_connection_limit,
      'heartbeat_grace_period'                 => $heartbeat_grace_period,
    })),
    require => Exec["create-service-control-instance-${instance_name}"],
  }

  if $service_manage {

    if $service_restart_on_config_change {
      File["${install_path}\\ServiceControl.exe.config"] ~> Exec["restart-slow-service-${instance_name}"]
    }

    exec { "restart-slow-service-${instance_name}":
      # lint:ignore:140chars
      command     => "try { Restart-Service -Name ${instance_name} -ErrorAction Stop; exit 0 } catch { Write-Output \$_.Exception.Message; exit 1 }",
      # lint:endignore
      logoutput   => true,
      refreshonly => true,
      provider    => 'powershell',
      subscribe   => File["${install_path}\\ServiceControl.exe.config"],
    }

    service { $instance_name:
      ensure => running,
      enable => true,
    }
  }

  } else {
    exec { "delete ServiceControl Instance ${instance_name}":
      command   => epp("${module_name}/delete-instance.ps1.epp", {
        'instance_name'         => $instance_name,
        'remove_db_on_delete'   => $remove_db_on_delete,
        'remove_logs_on_delete' => $remove_logs_on_delete,
      }),
      unless    => epp("${module_name}/query-instance.ps1.epp", {
        'instance_name' => $instance_name,
      }),
      logoutput => true,
      provider  => 'powershell',
    }
  }
}
