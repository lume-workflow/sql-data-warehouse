/*
======================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
======================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the 'BULK INSERT' command to load data from csv files to bronze tables.

PARAMETERS:
  None.
  This stored procedure does not accept any parameters or return any values.

USAGE EXAMPLE:
  EXEC bronze.load_bronze;
======================================================
*/

-- ================= --
-- LOAD BRONZE FILES --
-- ================= --

-- ========= --
-- CRM FILES --
-- ========= --

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
	SET @batch_start_time = GETDATE();
		PRINT '=====================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '=====================';

		PRINT '------------------';
		PRINT 'LOADING CRM TABLES';
		PRINT '------------------';

		-- crm.cust_info
		SET @start_time = GETDATE();
		PRINT '>>> Truncating bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>>> Inserting data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_crm\cust_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'

		-- crm_prd_info
		SET @start_time = GETDATE();
		PRINT '>>> Truncating table bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT '>>> Inserting data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_crm\prd_info.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'

		-- crm_sales_details
		SET @start_time = GETDATE();
		PRINT '>>> Truncating table bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT '>>> Inserting data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_crm\sales_details.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'


		-- ========= --
		-- EPR FILES --
		-- ========= --

		PRINT '------------------';
		PRINT 'LOADING ERP TABLES';
		PRINT '------------------';

		-- erp_cust_az12
		SET @start_time = GETDATE();
		PRINT '>>> Truncating table bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT '>>> Inserting data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_erp\CUST_AZ12.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'


		-- erp_loc_a101
		SET @start_time = GETDATE();
		PRINT '>>> Truncating table bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT '>>> Inserting data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_erp\LOC_A101.csv'
		WITH(
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'

		-- erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>>> Truncating table bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT '>>> Inserting data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Lume\Documents\Data Engineering\Data Warehouse Project\source_erp\PX_CAT_G1V2.csv'
		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)
		SET @end_time = GETDATE();
		PRINT '>> Loading duration = ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '----------------------------------------'
		SET @batch_end_time = GETDATE();
		PRINT '============================='
		PRINT 'BRONZE LAYER LOAD IS COMPLETE'
		PRINT '============================='


		PRINT '>> Total Loading duration = ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';

	END TRY
	BEGIN CATCH
		PRINT '========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT '========================================='
	END CATCH

END
