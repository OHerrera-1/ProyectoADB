/* ============================================================
   1) HABILITAR DATABASE MAIL
============================================================ */
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
GO

/* ============================================================
   2) CREAR CUENTA DE CORREO (OUTLOOK)
============================================================ */
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'CuentaOutlook',
    @email_address = 'uca.reportes@outlook.es',
    @display_name = 'Servidor SQL',
    @mailserver_name = 'smtp.office365.com',
    @port = 587,
    @enable_ssl = 1,
    @username = 'Uca.reportes@outlook.es',
    @password = 'Uca2324*';
GO


/* ============================================================
   3) CREAR PERFIL DE CORREO
============================================================ */
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'PerfilOutlook';
GO

EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'PerfilOutlook',
    @account_name = 'CuentaOutlook',
    @sequence_number = 1;
GO

EXEC msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'PerfilOutlook',
    @principal_name = 'public',
    @is_default = 1;
GO


/* ============================================================
   4) PRUEBA DE ENVÍO DE CORREO
============================================================ */
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'PerfilOutlook',
    @recipients = '0014254@uca.edu.sv',
    @subject = 'Prueba desde SQL Server Linux',
    @body = '¡Hola! El servidor SQL ya manda correos';
GO


/* ============================================================
   5) CREAR VIEW PARA MEDIR ESPACIO EN DISCO
============================================================ */
CREATE OR ALTER VIEW dbo.VW_DiscoSQL AS
SELECT
    vs.volume_mount_point,
    vs.total_bytes/1024/1024 AS TotalMB,
    vs.available_bytes/1024/1024 AS LibreMB,
    (vs.available_bytes * 100.0 / vs.total_bytes) AS PorcentajeLibre
FROM sys.master_files AS mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.file_id) AS vs;
GO


/* ============================================================
   6) JOB DE ALERTA DE POCO ESPACIO
============================================================ */
EXEC msdb.dbo.sp_add_job 
    @job_name = 'Alerta_Disponibilidad_Disco';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'Alerta_Disponibilidad_Disco',
    @step_name = 'CheckEspacio',
    @subsystem = 'TSQL',
    @command = '
IF EXISTS (
    SELECT 1 FROM dbo.VW_DiscoSQL WHERE PorcentajeLibre < 10
)
BEGIN
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''⚠️ Alerta: Poco espacio en disco'',
        @body = ''Tu instancia SQL Server tiene menos del 10% de espacio disponible.'';
END
';
GO

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = 'Cada_10_Min',
    @freq_type = 4,  -- diario
    @freq_interval = 1,
    @freq_subday_type = 4, -- minutos
    @freq_subday_interval = 10;
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = 'Alerta_Disponibilidad_Disco',
    @schedule_name = 'Cada_10_Min';
GO

EXEC msdb.dbo.sp_add_jobserver
    @job_name = 'Alerta_Disponibilidad_Disco';
GO


/* ============================================================
   7) JOB DE BACKUP DIARIO (CHECKSUM + VERIFY + MAIL)
============================================================ */
EXEC msdb.dbo.sp_add_job 
    @job_name = 'Backup_Diario';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'Backup_Diario',
    @step_name = 'BackupBD',
    @subsystem = 'TSQL',
    @command = '
DECLARE @ruta NVARCHAR(400) = 
    ''/var/opt/mssql/backups/Proyecto_'' 
    + CONVERT(VARCHAR(20), GETDATE(), 112)
    + ''.bak'';

BEGIN TRY
    BACKUP DATABASE Proyecto
    TO DISK = @ruta
    WITH INIT, CHECKSUM, STATS = 5;

    -- Verificar integridad del backup
    RESTORE VERIFYONLY FROM DISK = @ruta;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''Backup completado (FULL)'',
        @body = ''El backup FULL de la base de datos fue creado correctamente en '' + @ruta;
END TRY
BEGIN CATCH
    DECLARE @err NVARCHAR(400) = ERROR_MESSAGE();
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''ERROR: Backup FULL fallido'',
        @body = ''Falló el backup FULL de la base de datos. Error: '' + @err;
    THROW;
END CATCH;
';
GO

EXEC msdb.dbo.sp_add_schedule
    @schedule_name = 'Diario_2AM',
    @freq_type = 4,  -- diario
    @freq_interval = 1,
    @active_start_time = 020000; -- 2:00 AM
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = 'Backup_Diario',
    @schedule_name = 'Diario_2AM';
GO

EXEC msdb.dbo.sp_add_jobserver
    @job_name = 'Backup_Diario';
GO


/* ============================================================
   8) JOB DE BACKUP DE LOG (cada 15 minutos)
============================================================ */
EXEC msdb.dbo.sp_add_job @job_name = 'Backup_Log_15Min';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'Backup_Log_15Min',
    @step_name = 'BackupLog',
    @subsystem = 'TSQL',
    @command = '
DECLARE @ruta NVARCHAR(400) =
    ''/var/opt/mssql/backups/Proyecto_LOG_'' + CONVERT(VARCHAR(20), GETDATE(), 112)
    + ''_'' + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 108),'':'','') + ''.trn'';

BEGIN TRY
    BACKUP LOG MiBD
    TO DISK = @ruta
    WITH INIT, CHECKSUM, STATS = 5;

    RESTORE VERIFYONLY FROM DISK = @ruta;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''Backup LOG completado'',
        @body = ''Backup de log creado: '' + @ruta;
END TRY
BEGIN CATCH
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''ERROR: Backup LOG fallido'',
        @body = ERROR_MESSAGE();
    THROW;
END CATCH;
';
GO

-- Schedule: cada 15 minutos
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = 'Cada_15_Min',
    @freq_type = 4,               -- diario
    @freq_interval = 1,
    @freq_subday_type = 4,        -- minutos
    @freq_subday_interval = 15;   -- cada 15 minutos
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = 'Backup_Log_15Min',
    @schedule_name = 'Cada_15_Min';
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = 'Backup_Log_15Min';
GO


/* ============================================================
   9) JOB DE BACKUP DIFFERENTIAL (diario)
   (RTO: restaura FULL + DIFF + LOGs)
============================================================ */
EXEC msdb.dbo.sp_add_job @job_name = 'Backup_Differential';
GO

EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'Backup_Differential',
    @step_name = 'BackupDiff',
    @subsystem = 'TSQL',
    @command = '
DECLARE @ruta NVARCHAR(400) =
    ''/var/opt/mssql/backups/Proyecto_DIFF_'' + CONVERT(VARCHAR(20), GETDATE(), 112) + ''.bak'';

BEGIN TRY
    BACKUP DATABASE Proyec
    TO DISK = @ruta
    WITH DIFFERENTIAL, INIT, CHECKSUM, STATS = 5;

    RESTORE VERIFYONLY FROM DISK = @ruta;

    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''Backup DIFFERENTIAL completado'',
        @body = ''Backup DIFF creado: '' + @ruta;
END TRY
BEGIN CATCH
    EXEC msdb.dbo.sp_send_dbmail
        @profile_name = ''PerfilOutlook'',
        @recipients = ''Uca.reportes@outlook.es'',
        @subject = ''ERROR: Backup DIFF fallido'',
        @body = ERROR_MESSAGE();
    THROW;
END CATCH;
';
GO

-- Schedule: diario a las 14:00
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = 'Diario_14h',
    @freq_type = 4,
    @freq_interval = 1,
    @active_start_time = 140000; -- 14:00
GO

EXEC msdb.dbo.sp_attach_schedule
    @job_name = 'Backup_Differential',
    @schedule_name = 'Diario_14h';
GO

EXEC msdb.dbo.sp_add_jobserver @job_name = 'Backup_Differential';
GO