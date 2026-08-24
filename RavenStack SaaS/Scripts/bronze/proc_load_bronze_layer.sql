CREATE OR ALTER PROCEDURE bronze.load_saas_bronze
AS
  BEGIN
	DECLARE 
	   @start_time DATETIME,
	   @end_time DATETIME,
	   @batch_start_time DATETIME,
	   @batch_end_time DATETIME

	   BEGIN TRY
			SET @batch_start_time = GETDATE();

			PRINT'===================================================='
			PRINT'Loading SaaS Bronze Tables'
			PRINT'===================================================='

			-----------------------------------------
			-- accounts
			-----------------------------------------
			SET @start_time = GETDATE();
			PRINT'Truncating Table : bronze.accounts'
			TRUNCATE TABLE bronze.accounts;
			PRINT'Inserting Data Into : bronze.accounts '
			BULK INSERT bronze.accounts
			FROM 'C:\SQLData\RavenStack SaaS\dataset\accounts.csv' 
			WITH
			(
            FORMAT='CSV',
            FIRSTROW=2,
            FIELDQUOTE='"',
            CODEPAGE='65001',
            TABLOCK
        
        );

		 SET @end_time = GETDATE();
		 PRINT '>> Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR(10) ) + ' seconds';
		 PRINT '------------------------------------------------------------'

		-----------------------------------------
		-- subscriptions
		-----------------------------------------
		 SET @start_time = GETDATE();
			PRINT'Truncating Table : bronze.subscriptions'
			TRUNCATE TABLE bronze.subscriptions;
			PRINT'Inserting Data Into : bronze.subscriptions '
			BULK INSERT bronze.subscriptions
			FROM 'C:\SQLData\RavenStack SaaS\dataset\subscriptions.csv' 
			WITH
			(
            FORMAT='CSV',
            FIRSTROW=2,
            FIELDQUOTE='"',
            CODEPAGE='65001',
            TABLOCK
          
        );

		 SET @end_time = GETDATE();
		 PRINT '>> Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time)  AS VARCHAR(10) ) + ' seconds';
		 PRINT '------------------------------------------------------------';

		-----------------------------------------
		-- churn_events
		-----------------------------------------
		 SET @start_time = GETDATE();
			PRINT'Truncating Table : bronze.churn_events'
			TRUNCATE TABLE bronze.churn_events;
			PRINT'Inserting Data Into : bronze.churn_events '
			BULK INSERT bronze.churn_events
			FROM 'C:\SQLData\RavenStack SaaS\dataset\churn_events.csv' 
			WITH
			(
            FORMAT='CSV',
            FIRSTROW=2,
            FIELDQUOTE='"',
            CODEPAGE='65001',
            TABLOCK
       
        );

		 SET @end_time = GETDATE();
		 PRINT '>> Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR(10) ) + ' seconds';
		 PRINT '------------------------------------------------------------';

		-----------------------------------------
		-- feature_usage
		-----------------------------------------
		 SET @start_time = GETDATE();
			PRINT'Truncating Table : bronze.feature_usage'
			TRUNCATE TABLE bronze.feature_usage;
			PRINT'Inserting Data Into : bronze.feature_usage '
			BULK INSERT bronze.feature_usage
			FROM 'C:\SQLData\RavenStack SaaS\dataset\feature_usage.csv' 
			WITH
			(
            FORMAT='CSV',
            FIRSTROW=2,
            FIELDQUOTE='"',
            CODEPAGE='65001',
            TABLOCK
        
        );

		 SET @end_time = GETDATE();
		 PRINT '>> Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time)  AS VARCHAR(10) ) + ' seconds';
		 PRINT '------------------------------------------------------------';

		-----------------------------------------
		-- support_tickets
		-----------------------------------------
		 SET @start_time = GETDATE();
			PRINT'Truncating Table : bronze.support_tickets'
			TRUNCATE TABLE bronze.support_tickets;
			PRINT'Inserting Data Into : bronze.support_tickets '
			BULK INSERT bronze.support_tickets
			FROM 'C:\SQLData\RavenStack SaaS\dataset\support_tickets.csv' 
			WITH
			(
            FORMAT='CSV',
            FIRSTROW=2,
            FIELDQUOTE='"',
            CODEPAGE='65001',
            TABLOCK
           
        );

		 SET @end_time = GETDATE();
		 PRINT '>> Load Duration : ' + CAST(DATEDIFF(second,@start_time,@end_time)  AS VARCHAR(10) ) + ' seconds';
		 PRINT '------------------------------------------------------------';

		 SET @batch_end_time = GETDATE();

        PRINT '================================================';
        PRINT 'SaaS Bronze Load Completed';
        PRINT 'Total Duration : '
            + CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS VARCHAR(10))
            + ' seconds';
        PRINT '================================================';

	   END TRY

	   BEGIN CATCH
			PRINT '=========================================='
		    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		    PRINT 'Error Message' + ERROR_MESSAGE();
		    PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		    PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		    PRINT '=========================================='
	   END CATCH
END 


exec bronze.load_saas_bronze