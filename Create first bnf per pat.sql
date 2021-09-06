### Prescription dataset ###

SELECT a.patid, a.bnfcode, min(a.eventdate), COUNT(*) FROM therapy AS a
JOIN (SELECT * FROM hes_patient LIMIT 120000) AS b USING (patid)
GROUP BY a.patid, a.bnfcode
LIMIT 10000000
;
# Save this table to csv "bnf_120k_incomplete"

CREATE TABLE bnf_120k_incomplete (
patid INT(20),
bnfcode INT(5),
eventdate DATE,
num INT(5)
);

LOAD DATA LOCAL INFILE 'bnf_120k_incomplete.csv'
INTO TABLE bnf_120k_incomplete
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Add additional columns
SELECT a.*, b.gender, b.yob, c.gen_ethnicity, d.bnf
FROM bnf_120k_incomplete AS a
JOIN 17_205R_Providencia.patient AS b USING (patid)
JOIN (SELECT * FROM 17_205R_Providencia.hes_patient LIMIT 120000) AS c USING (patid)
JOIN lookup_tables.lookup_bnfcodes AS d USING (bnfcode)
LIMIT 10000000
;
# Save this table to csv to pass into Python preprocessing

### Diagnosis dataset ###

SELECT a.patid,  substr(a.icd, 1,3), min(a.epistart), min(spno), COUNT(*) FROM hes_diag_epi AS a
JOIN (SELECT * FROM hes_patient LIMIT 250000) AS b USING (patid)
GROUP BY a.patid, substr(a.icd, 1,3)
LIMIT 5000000
;
# Save this table to csv "hes_250k_incomplete"

CREATE TABLE hes_250k_incomplete (
patid INT(20),
icd CHAR(3),
epistart DATE,
spno INT(20),
num INT(5)
);

LOAD DATA LOCAL INFILE 'hes_250k_incomplete.csv'
INTO TABLE hes_250k_incomplete
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Add additional columns
SELECT a.*, b.gender, b.yob, c.gen_ethnicity
FROM hes_250k_incomplete AS a
JOIN 17_205R_Providencia.patient AS b USING (patid)
JOIN (SELECT * FROM 17_205R_Providencia.hes_patient LIMIT 250000) AS c USING (patid)
LIMIT 10000000
;
# Save table as "hes_250k_incomplete.csv"

CREATE TABLE hes_250k_incompleteV2 (
patid INT(20),
icd CHAR(3),
epistart DATE,
spno INT(20),
num INT(5),
gender INT(2),
yob INT(5),
gen_ethnicity CHAR(10)
);

LOAD DATA LOCAL INFILE 'hes_250k_incomplete.csv'
INTO TABLE hes_250k_incompleteV2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Add admimeth column in order to match on ED/IP admission:
-- admimeth found in hes_hospital so first get that table for the 250k patients
-- Then put into new SQL table with primary key on spno (so that it is indexed)

SELECT a.* FROM (SELECT * FROM hes_patient LIMIT 250000) AS T JOIN hes_hospital AS a USING (patid)
LIMIT 100000000;
# Save as "250k_hes_hosp.csv"

CREATE TABLE 250k_hosp (
patid INT(20),
spno INT(20),
admidate DATE,
discharged DATE,
admimeth CHAR(2),
admisorc INT(2),
disdest INT(2),
dismeth INT(1),
duration INT(5),
PRIMARY KEY (spno)
);

LOAD DATA LOCAL INFILE '250k_hes_hosp.csv'
INTO TABLE 250k_hosp
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT a.*, b.admimeth
FROM hes_250k_incompleteV2 AS a
JOIN 250k_hosp AS b USING (spno)
LIMIT 10000000;
