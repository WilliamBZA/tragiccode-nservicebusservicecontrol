# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

_Public Classes_

* [`nservicebusservicecontrol`](#nservicebusservicecontrol): Installs and configures Particular's Service Control Monitoring Tool.

_Private Classes_

* `nservicebusservicecontrol::config`: This class handles the configuration of servicecontrol.
* `nservicebusservicecontrol::install`: This class handles the management of the servicecontrol installer and package.

**Defined types**

* [`nservicebusservicecontrol::instance`](#nservicebusservicecontrolinstance): Manages Service Control Instances.

## Classes

### nservicebusservicecontrol

Installs and configures Particular's Service Control Monitoring Tool.

#### Parameters

The following parameters are available in the `nservicebusservicecontrol` class.

##### `package_ensure`

Data type: `Enum['present', 'installed', 'absent']`

Whether to install the ServiceControl package.

Default value: 'present'

##### `remote_file_path`

Data type: `Stdlib::Absolutepath`

The location to store the downloaded installer on the local system.

Default value: 'C:\\Particular.ServiceControl-3.6.1.exe'

##### `remote_file_source`

Data type: `Stdlib::Httpsurl`

The http/https location in which a specific version of servicecontrol can be downloaded from.

Default value: 'https://github.com/Particular/ServiceControl/releases/download/3.6.1/Particular.ServiceControl-3.6.1.exe'

##### `license_xml`

Data type: `Optional[String]`

A valid NServiceBus XML License.

Default value: ''

## Defined types

### nservicebusservicecontrol::instance

Manages Service Control Instances.

#### Parameters

The following parameters are available in the `nservicebusservicecontrol::instance` defined type.

##### `ensure`

Data type: `Enum['present', 'absent']`

Specifies whether the instance should exist.

##### `instance_name`

Data type: `String`

Specify the name of the ServiceControl Instance (title).

Default value: $title

##### `install_path`

Data type: `Stdlib::Absolutepath`

Specify the directory to use for this ServiceControl Instance.

Default value: "C:\\Program Files (x86)\\Particular Software\\${instance_name}"

##### `db_path`

Data type: `Stdlib::Absolutepath`

Specify the directory that will contain the nservicebusservicecontrol database for this ServiceControl Instance.

Default value: "C:\\ProgramData\\Particular\\ServiceControl\\${instance_name}\\DB"

##### `db_index_storage_path`

Data type: `Stdlib::Absolutepath`

Specify the path for the indexes on disk.

Default value: "${db_path}\\Indexes"

##### `db_logs_path`

Data type: `Stdlib::Absolutepath`

Specify the path for the Esent logs on disk.

Default value: "${db_path}\\logs"

##### `log_path`

Data type: `Stdlib::Absolutepath`

Specify the directory to use for this ServiceControl Logs.

Default value: "C:\\ProgramData\\Particular\\ServiceControl\\${instance_name}\\Logs"

##### `instance_log_level`

Data type: `Nservicebusservicecontrol::Log_level`

Specify the level of logging that should be used in ServiceControl logs.

Default value: 'Warn'

##### `host_name`

Data type: `Stdlib::Fqdn`

Specify the hostname to use in the URLACL.

Default value: 'localhost'

##### `port`

Data type: `Stdlib::Port`

Specify the port number to listen on. If this is the only ServiceControl instance then 33333 is recommended.

Default value: 33333

##### `database_maintenance_port`

Data type: `Stdlib::Port`

Specify the database maintenance port number to listen on. If this is the only ServiceControl instance then 33334 is recommended.

Default value: 33334

##### `expose_ravendb`

Data type: `Boolean`

Specify if the embedded ravendb database should be accessible outside of maintenance mode.

Default value: `false`

##### `ravendb_log_level`

Data type: `Nservicebusservicecontrol::Log_level`

Specify the level of logging that should be used in ravendb logs.

Default value: 'Warn'

##### `error_queue`

Data type: `String`

Specify ErrorQueue name to consume messages from.

Default value: 'error'

##### `audit_queue`

Data type: `String`

Specify AuditQueue name to consume messages from.

Default value: 'audit'

##### `error_log_queue`

Data type: `Optional[String]`

Specify Queue name to forward error messages to.

Default value: 'error.log'

##### `audit_log_queue`

Data type: `Optional[String]`

Specify Queue name to forward eudit messages to.

Default value: 'audit.log'

##### `transport`

Data type: `Nservicebusservicecontrol::Transport`

Specify the NServiceBus Transport to use.

Default value: 'MSMQ'

##### `display_name`

Data type: `String`

Specify the Windows Service Display name. If unspecified the instance name will be used.

Default value: $instance_name

##### `connection_string`

Data type: `Optional[String]`

Specify the connection string to use to connect to the queuing system.

Default value: `undef`

##### `description`

Data type: `String`

Specify the description to use on the Windows Service for this instance.

Default value: 'A ServiceControl Instance'

##### `forward_audit_messages`

Data type: `Boolean`

Specify if audit messages are forwarded to the queue specified by AuditLogQueue.

Default value: `true`

##### `forward_error_messages`

Data type: `Boolean`

Specify if audit messages are forwarded to the queue specified by ErrorLogQueue.

Default value: `false`

##### `service_account`

Data type: `String`

The Account to run the Windows service.

Default value: 'LocalSystem'

##### `service_account_password`

Data type: `Optional[String]`

The password for the ServiceAccount.

Default value: `undef`

##### `service_restart_on_config_change`

Data type: `Boolean`

Specify if the servicecontrol instance's windows service should be restarted to pick up changes to its configuration file.

Default value: `true`

##### `audit_retention_period`

Data type: `String`

Specify the period to keep an audit message before it is deleted.

Default value: '30.00:00:00'

##### `error_retention_period`

Data type: `String`

Specify thd grace period that faulted messages are kept before they are deleted.

Default value: '15.00:00:00'

##### `event_retention_period`

Data type: `String`

Specifies the period to keep event logs before they are deleted.

Default value: '14.00:00:00'

##### `expiration_process_timer_in_seconds`

Data type: `Integer`

Specifies the number of seconds to wait between checking for expired messages.

Default value: 600

##### `expiration_process_batch_size`

Data type: `Integer`

Specifies the batch size to use when checking for expired messages.

Default value: 65512

##### `hours_to_keep_messages_before_expiring`

Data type: `Integer`

Specifies the number of hours to keep a message before it is deleted.

Default value: 720

##### `maximum_message_throughput_per_second`

Data type: `Integer`

Specifies the maximum throughput of messages ServiceControl will handle per second and is necessary to avoid overloading the underlying messages database.

Default value: 350

##### `max_body_size_to_store`

Data type: `Integer`

Specifies the upper limit on body size to be configured.

Default value: 102400

##### `http_default_connection_limit`

Data type: `Integer`

Specifies the maximum number of concurrent connections allowed by ServiceControl.

Default value: 100

##### `heartbeat_grace_period`

Data type: `String`

Specifies the period that defines whether an endpoint is considered alive or not since the last received heartbeat.

Default value: '00:00:40'

##### `service_manage`

Data type: `Boolean`

Specifies whether or not to manage the desired state of the windows service for this instance.

Default value: `true`

##### `skip_queue_creation`

Data type: `Boolean`

Normally an instance will attempt to create the queues that it uses. If this flag is set, queue creation will be skipped.

Default value: `false`

##### `remove_db_on_delete`

Data type: `Boolean`



Default value: `false`

##### `remove_logs_on_delete`

Data type: `Boolean`



Default value: `false`

##### `automatic_instance_upgrades`

Data type: `Boolean`



Default value: `true`
