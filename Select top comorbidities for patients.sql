# ICD Section
SELECT section, COUNT(*) as 'num' FROM (
	SELECT * FROM hes_120k
	WHERE patid in (SELECT * FROM(
	SELECT distinct patid from hes_120k
	where section = 'R40-R46'
	LIMIT 1000000) AS T)
	LIMIT 1000000) AS T2
GROUP BY section
;

# ICD Chapter
SELECT chapter, COUNT(*) as 'num' FROM (
	SELECT * FROM hes_120k
	WHERE patid in (SELECT * FROM(
	SELECT distinct patid from hes_120k
	where chapter = 19
	LIMIT 1000000) AS T)
	LIMIT 1000000) AS T2
GROUP BY chapter;

# BNF Section
SELECT bnfsection, COUNT(*) as 'num' FROM (
	SELECT * FROM bnf_120k
	WHERE patid in (SELECT * FROM(
	SELECT distinct patid from bnf_120k
	where bnfsection = 1201
	LIMIT 1000000) AS T)
	LIMIT 1000000) AS T2
GROUP BY bnfsection
;

# BNF Chapter
SELECT bnfchapter, COUNT(*) as 'num' FROM (
	SELECT * FROM bnf_120k
	WHERE patid in (SELECT * FROM(
	SELECT distinct patid from bnf_120k
	where bnfchapter = 6
	LIMIT 1000000) AS T)
	LIMIT 1000000) AS T2
GROUP BY bnfchapter
;