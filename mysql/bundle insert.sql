DELIMITER //
DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test()
BEGIN
	DECLARE i INT;
	SET i = 0;
	lp: LOOP
		INSERT INTO roster_worker VALUES (0, 
			ELT(CEILING(rand() * 4), 'Joseph', 'Kaye', 'Linda', 'Baron'),
			ELT(CEILING(rand() * 4), 'WE', 'RNG', 'SKT', 'SSW'),
			NOW()
		);
		SET i = i + 1;
		IF i > 100 THEN
			LEAVE lp; 
		END IF; 
	END LOOP lp;
END
//
DELIMITER ;
CALL test();
