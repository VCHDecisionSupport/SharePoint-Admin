USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSandboxedRequestsMonitoredData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSandboxedRequestsMonitoredData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSandboxedRequestsMonitoredData]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @UsagePID Int, @SiteId UniqueIdentifier, @SolutionId UniqueIdentifier, @SolutionHash NVarChar(44), @RequestId Int, @WorkerPID Int, @ProxyPID Int, @PercentProcessorTime Float, @ProcessVirtualBytes Float, @ProcessHandleCount Float, @ProcessThreadCount Float, @ProcessIOBytes Float, @CPUExecutionTime Float, @ProcessCPUCycles Float, @AbnormalProcessTerminationCount Float, @CriticalExceptionCount Float, @UnhandledExceptionCount Float, @UnresponsiveprocessCount Float,         
        @MachineName nvarchar(128),
        @LogTime datetime 
    AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @PartitionId tinyint,
                @UTCDate datetime,
                @ConfigName nvarchar(255),
                @RetentionPeriod smallint,
		@MaxBytes bigint
        SELECT @UTCDate = getutcdate()
        -- We probably want to discard anything older than retention policy
        -- and messages from the future should be similarly ignored
        -- Just ignore without error
        SELECT @ConfigName = ''Retention Period - SandboxedRequestsMonitoredData''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - SandboxedRequestsMonitoredData''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''SandboxedRequestsMonitoredData'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''SandboxedRequestsMonitoredData_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[SandboxedRequestsMonitoredData_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, UsagePID, SiteId, SolutionId, SolutionHash, RequestId, WorkerPID, ProxyPID, PercentProcessorTime, ProcessVirtualBytes, ProcessHandleCount, ProcessThreadCount, ProcessIOBytes, CPUExecutionTime, ProcessCPUCycles, AbnormalProcessTerminationCount, CriticalExceptionCount, UnhandledExceptionCount, UnresponsiveprocessCount, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @UsagePID, @SiteId, @SolutionId, @SolutionHash, @RequestId, @WorkerPID, @ProxyPID, @PercentProcessorTime, @ProcessVirtualBytes, @ProcessHandleCount, @ProcessThreadCount, @ProcessIOBytes, @CPUExecutionTime, @ProcessCPUCycles, @AbnormalProcessTerminationCount, @CriticalExceptionCount, @UnhandledExceptionCount, @UnresponsiveprocessCount, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @UsagePID Int, @SiteId UniqueIdentifier, @SolutionId UniqueIdentifier, @SolutionHash NVarChar(44), @RequestId Int, @WorkerPID Int, @ProxyPID Int, @PercentProcessorTime Float, @ProcessVirtualBytes Float, @ProcessHandleCount Float, @ProcessThreadCount Float, @ProcessIOBytes Float, @CPUExecutionTime Float, @ProcessCPUCycles Float, @AbnormalProcessTerminationCount Float, @CriticalExceptionCount Float, @UnhandledExceptionCount Float, @UnresponsiveprocessCount Float,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @UsagePID, @SiteId, @SolutionId, @SolutionHash, @RequestId, @WorkerPID, @ProxyPID, @PercentProcessorTime, @ProcessVirtualBytes, @ProcessHandleCount, @ProcessThreadCount, @ProcessIOBytes, @CPUExecutionTime, @ProcessCPUCycles, @AbnormalProcessTerminationCount, @CriticalExceptionCount, @UnhandledExceptionCount, @UnresponsiveprocessCount, 
            @UTCDate
    END' 
END
GO
