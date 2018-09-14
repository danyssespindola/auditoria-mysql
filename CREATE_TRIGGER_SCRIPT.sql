CREATE PROCEDURE CREATE_TRIGGER_SCRIPT (IN Trigger_type VARCHAR(40), 
										IN Trigger_event VARCHAR(40), 
										IN Trigger_databasename VARCHAR(40), 
										IN trigger_tablename VARCHAR(40))
BEGIN  
	DECLARE fieldnameCursor_finished  INT DEFAULT 10;
	DECLARE current_fieldname  VARCHAR(50) DEFAULT ""; 
	DECLARE fullexcutecmd VARCHAR(5000);
	DECLARE fullexcutecmd1 VARCHAR(5000);
	DECLARE fullexcutecmd2 VARCHAR(5000);
	DECLARE fullexcutecmd3 VARCHAR(60000);

	/*Declare and populate the cursor with a SELECT statement */  	
	  
	DECLARE fieldname CURSOR FOR 	
		SELECT column_name 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE TABLE_SCHEMA = Trigger_databasename 
		AND TABLE_NAME = trigger_tablename ;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fieldnameCursor_finished = 1;     

	/*Specify what to do when no more records found, notice that the handler declaration must appear after variable and cursor declaration inside the stored procedures*/  	
 
	SET fullexcutecmd1= CONCAT( ' CREATE TRIGGER ',trigger_tablename,'_',trigger_type,'_',trigger_event,'_TRIGGER ',trigger_type,' ',trigger_event,' ON ',trigger_tablename,' FOR EACH ROW BEGIN ');   

		OPEN fieldname ;	
		set fullexcutecmd2=' ';
		set fullexcutecmd3=' ';

		get_fieldlist: LOOP	
 
			FETCH fieldname INTO current_fieldname;	
			IF fieldnameCursor_finished = 1 THEN 	
				LEAVE get_fieldlist;	
			END IF;	
 
			SET fullexcutecmd2 = CONCAT('INSERT INTO AUDITORIA (TABLE_NAME, CAMPO, VALOR_ANTERIOR, VALOR_NOVO, USUARIO, DATA) values (''',
										trigger_tablename,''',''',current_fieldname,''',','OLD.',current_fieldname,',','NEW.',current_fieldname,', USER(), now());');
			set fullexcutecmd3= CONCAT(fullexcutecmd3,fullexcutecmd2); 
			
   
		END LOOP  get_fieldlist;	
	close fieldname;                             

	set fullexcutecmd3= CONCAT(fullexcutecmd1,fullexcutecmd3,' END; '); 
	 select fullexcutecmd3;  
END;