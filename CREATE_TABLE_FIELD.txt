CREATE PROCEDURE CREATE_TABLE_FIELD(IN Trigger_databasename 	VARCHAR(40), 
									IN trigger_tablename 		VARCHAR(40),
									IN field_name				VARCHAR(30),
									IN field_tipo				VARCHAR(50))
BEGIN  
	DECLARE fullexcutecmd1 		VARCHAR(5000);
	DECLARE fullexcutecmd2 		VARCHAR(5000);
	DECLARE count_field_name   	INT(5);
	DECLARE count_field_tipo   	INT(5);
	
	SELECT count(column_name)
	INTO count_field_name
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_SCHEMA = Trigger_databasename 
	AND TABLE_NAME = trigger_tablename 
	and COLUMN_NAME = field_name;
					
	SELECT count(column_name)
	INTO count_field_tipo
	FROM INFORMATION_SCHEMA.COLUMNS 
	WHERE TABLE_SCHEMA = Trigger_databasename 
	AND TABLE_NAME = trigger_tablename 
	and COLUMN_NAME = field_name
	and COLUMN_TYPE = field_tipo;
	
	if count_field_name > 0 and count_field_tipo = 0 then
		SET fullexcutecmd1= CONCAT(' ALTER TABLE ',Trigger_databasename,'.',trigger_tablename, ' drop column ',field_name);
		select fullexcutecmd1;
		/*PREPARE stmt FROM fullexcutecmd1;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;*/
	end if;
	
	if count_field_tipo =  0 then
		SET fullexcutecmd2= CONCAT(' ALTER TABLE ',Trigger_databasename,'.',trigger_tablename, ' add ',field_name,' ',field_tipo);
		select fullexcutecmd2;
		/*PREPARE stmt FROM fullexcutecmd2;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;*/
	end if; 
END