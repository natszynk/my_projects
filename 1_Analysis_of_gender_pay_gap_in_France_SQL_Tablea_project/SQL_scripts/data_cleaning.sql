-- TABLE net_salary_per_town_categories

-- Renaming columns:

ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "CODGEO"	 TO   CODGEO	;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "LIBGEO"    TO   LIBGEO    ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHM14"    TO   SNHM14    ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMC14"   TO   SNHMC14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMP14"   TO   SNHMP14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHME14"   TO   SNHME14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMO14"   TO   SNHMO14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMF14"   TO   SNHMF14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMFC14"  TO   SNHMFC14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMFP14"  TO   SNHMFP14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMFE14"  TO   SNHMFE14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMFO14"  TO   SNHMFO14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMH14"   TO   SNHMH14   ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMHC14"  TO   SNHMHC14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMHP14"  TO   SNHMHP14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMHE14"  TO   SNHMHE14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMHO14"  TO   SNHMHO14  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHM1814"  TO   SNHM1814  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHM2614"  TO   SNHM2614  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHM5014"  TO   SNHM5014  ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMF1814" TO   SNHMF1814 ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMF2614" TO   SNHMF2614 ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMF5014" TO   SNHMF5014 ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMH1814" TO   SNHMH1814 ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMH2614" TO   SNHMH2614 ;
ALTER TABLE projekt.net_salary_per_town_categories RENAME COLUMN "SNHMH5014" TO   SNHMH5014 ;
-- 
-- Adding comments to columns:

COMMENT ON COLUMN projekt.net_salary_per_town_categories.codgeo    IS 'unique code of the town';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.libgeo    IS 'name of the town';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM14    IS 'mean net salary';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMC14   IS 'mean net salary per hour for executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMP14   IS 'mean net salary per hour for middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHME14   IS 'mean net salary per hour for employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMO14   IS 'mean net salary per hour for worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF14   IS 'mean net salary for women';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFC14  IS 'mean net salary per hour for feminin executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFP14  IS 'mean net salary per hour for feminin middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFE14  IS 'mean net salary per hour for feminin employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMFO14  IS 'mean net salary per hour for feminin worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH14   IS 'mean net salary for man';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHC14  IS 'mean net salary per hour for masculin executive';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHP14  IS 'mean net salary per hour for masculin middle manager';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHE14  IS 'mean net salary per hour for masculin employee';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMHO14  IS 'mean net salary per hour for masculin worker';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM1814  IS 'mean net salary per hour for 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM2614  IS 'mean net salary per hour for 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHM5014  IS 'mean net salary per hour for >50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF1814 IS 'mean net salary per hour for women between 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF2614 IS 'mean net salary per hour for women between 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMF5014 IS 'mean net salary per hour for women >50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH1814 IS 'mean net salary per hour for men between 18-25 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH2614 IS 'mean net salary per hour for men between 26-50 years old';
COMMENT ON COLUMN projekt.net_salary_per_town_categories.SNHMH5014 IS 'mean net salary per hour for men >50 years old'; 

-- DATA CLEANING:
-- Searching for NULL values:

select *
from net_salary_per_town_categories
where codgeo		is null or
	  libgeo        is null or 
 	  SNHM14        is null or 
      SNHMC14       is null or  
      SNHMP14       is null or  
      SNHME14       is null or 
      SNHMO14       is null or 
      SNHMF14       is null or
	  SNHMFC14 		is null or
      SNHMFP14      is null or
      SNHMFE14      is null or
      SNHMFO14      is null or
      SNHMH14       is null or
      SNHMHC14      is null or
      SNHMHP14      is null or
      SNHMHE14 		is null or
      SNHMHO14      is null or
      SNHM1814      is null or
      SNHM2614      is null or
      SNHM5014      is null or
      SNHMF1814     is null or
      SNHMF2614     is null or
      SNHMF5014     is null or
      SNHMH1814     is null or
      SNHMH2614     is null or
      SNHMH5014     is null;


-- There are no NULL values.

-- Searching for duplicates based on CODGEO numbers:
select 
	(select distinct 
		count(codgeo)
	from
		net_salary_per_town_categories) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	net_salary_per_town_categories;

-- There are no duplicates.

-- Searching for duplicates based on libgeo column:
select count(distinct libgeo),
count(libgeo)
from net_salary_per_town_categories nsptc ;

-- There are few duplicates:
select
  libgeo,
  count(*)
from net_salary_per_town_categories nsptc 
group by
  libgeo
having count(*) > 1;

select * from
  (select *, 
  		  count(*) over (partition by libgeo) as number_of_rows
  from net_salary_per_town_categories) duplicated_rows
where duplicated_rows.number_of_rows > 1;

-- The name of a city is not a unique quantity. There may be several cities with the same name
-- in different parts of the country. To make sure that this is not an error, I compare these 
-- values with the population table, assuming that the correct city names are found here.

select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	population.codgeo,
	population.libgeo,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where net_salary_per_town_categories.codgeo in  
	(select codgeo 
	from
  		(select *, 
  		 	count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1)
order by net_salary_per_town_categories.libgeo;


-- All values are identical - they appear in the same form in both tables.
 
-- I make an analogous comparison with the table  base_etablissement_par_tranche_effectif:

select distinct
	net_salary_per_town_categories.codgeo, 
	net_salary_per_town_categories.libgeo,
	base_etablissement_par_tranche_effectif."CODGEO",
	base_etablissement_par_tranche_effectif."LIBGEO",
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where net_salary_per_town_categories.codgeo in  
	(select codgeo from
  		(select *, 
  		  		count(*) over (partition by libgeo) as number_of_rows
  		from net_salary_per_town_categories) duplicated_rows
		where duplicated_rows.number_of_rows > 1)
order by net_salary_per_town_categories.libgeo;

-- Also all values are identical - they appear in the same form in both tables.

-- In the following section, I check the consistency of all records (not just duplicate ones) 
-- for the net_salary_per_town_categories and population tables:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	population.codgeo as codgeo_p,
	population.libgeo as libgeo_p,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where (case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end) = 'diffrent'
order by net_salary_per_town_categories.libgeo;

-- I perform an analogous operation for the net_salary_per_town_categories 
-- and base_etablissement_par_tranche_effectif tables:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	base_etablissement_par_tranche_effectif."CODGEO" as codgeo_bepte,
	base_etablissement_par_tranche_effectif."LIBGEO" as libgeo_bepte, 
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where (case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end) = 'diffrent'
order by net_salary_per_town_categories.libgeo;

-- I find all records for which there are inconsistencies in the city name, for both tables:

select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join population
on net_salary_per_town_categories.codgeo = population.codgeo
where (case 
		when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
		else 'diffrent'
	end) = 'diffrent'
union
select distinct
	net_salary_per_town_categories.codgeo as codgeo_nsptc, 
	net_salary_per_town_categories.libgeo as libgeo_nsptc,
	case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end as libgeo_comparison
from net_salary_per_town_categories 
left join base_etablissement_par_tranche_effectif
on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
where (case 
		when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
		else 'diffrent'
	end) = 'diffrent';

-- After careful analysis of the inconsistent records, it appears that some of these are due to typos 
-- in the names of cities. However, given the small number of such errors and the need for consistency 
-- in the datasets, to facilitate further analysis I remove these records from the table net_salary_per_town_categories:

delete 
from net_salary_per_town_categories 
where net_salary_per_town_categories.codgeo in
(
	select distinct
		net_salary_per_town_categories.codgeo as codgeo_nsptc 
	from net_salary_per_town_categories 
	left join population
	on net_salary_per_town_categories.codgeo = population.codgeo
	where (case 
			when net_salary_per_town_categories.libgeo = population.libgeo then 'identical'
			else 'diffrent'
		end) = 'diffrent'
union
	select distinct
		net_salary_per_town_categories.codgeo as codgeo_nsptc 
	from net_salary_per_town_categories 
	left join base_etablissement_par_tranche_effectif
	on net_salary_per_town_categories.codgeo = base_etablissement_par_tranche_effectif."CODGEO"
	where (case 
			when net_salary_per_town_categories.libgeo = base_etablissement_par_tranche_effectif."LIBGEO" then 'identical'
			else 'diffrent'
		end) = 'diffrent');

	
select count(distinct codgeo) as number_or_remaining_records
from net_salary_per_town_categories nsptc; 

--In total, I removed earnings information for 125 cities from the table. 
--After processing, [%] of the data remained:

select round(count(distinct codgeo)::numeric/(count(distinct codgeo)::numeric+125)*100,2) as percetage_of_remaining_data
from net_salary_per_town_categories nsptc; 

-- TABLE population:
-- Renaming columns:

ALTER TABLE projekt.population RENAME COLUMN "NIVGEO" TO nivgeo;
ALTER TABLE projekt.population RENAME COLUMN "CODGEO" TO codgeo;
ALTER TABLE projekt.population RENAME COLUMN "LIBGEO" TO libgeo;
ALTER TABLE projekt.population RENAME COLUMN "MOCO" TO moco;
ALTER TABLE projekt.population RENAME COLUMN "AGEQ80_17" TO ageq80_17;
ALTER TABLE projekt.population RENAME COLUMN "SEXE" TO sexe;
ALTER TABLE projekt.population RENAME COLUMN "NB" TO nb;

-- Też dodaję do niej komentarze:

COMMENT ON COLUMN projekt.population.nivgeo    IS 'geographic level (arrondissement, communes…)';
COMMENT ON COLUMN projekt.population.codgeo    IS 'unique code for the town';
COMMENT ON COLUMN projekt.population.libgeo    IS 'name of the town (might contain some utf-8 errors, this information has better quality namegeographicinformation)';
COMMENT ON COLUMN projekt.population.moco      IS 'cohabitation mode : [list and meaning available in Data description]';
COMMENT ON COLUMN projekt.population.ageq80_17 IS 'age category (slice of 5 years) | ex : 0 -> people between 0 and 4 years old';
COMMENT ON COLUMN projekt.population.sexe      IS 'sex, 1 for men | 2 for women';
COMMENT ON COLUMN projekt.population.nb        IS 'number of people in the category';

-- Searching for NULL values:

select *
from population
where nivgeo is null or 
 	  codgeo is null or 
      libgeo is null or  
      moco is null or  
      ageq80_17 is null or 
      sexe is null or 
      nb is null;

-- Searching for duplicates:
     
select 
	(select distinct 
		count(codgeo)
	from
		population) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	population;

-- There are nor NULL values and duplicates.

-- TABLE base_etablissement_par_tranche_effectif
-- Renaming columns:
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "CODGEO"   TO CODGEO;  
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "LIBGEO"   TO LIBGEO;  
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "REG"      TO REG;     
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "DEP"      TO DEP;     
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TST"   TO E14TST;  
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS0ND" TO E14TS0ND;
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS1"   TO E14TS1;  
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS6"   TO E14TS6;  
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS10"  TO E14TS10; 
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS20"  TO E14TS20; 
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS50"  TO E14TS50; 
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS100" TO E14TS100;
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS200" TO E14TS200;
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME COLUMN "E14TS500" TO E14TS500;
											 
-- Adding comments to columns:

COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.CODGEO   IS 'geographique code for the town (can be joined with codeinsee column from namegeographic_information.csv)';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.LIBGEO   IS 'name of the town (in french)';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.REG      IS 'region number';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.DEP      IS 'depatment number';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TST   IS 'total number of firms in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS0ND IS 'number of unknown or null size firms in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS1   IS 'number of firms with 1 to 5 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS6   IS 'number of firms with 6 to 9 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS10  IS 'number of firms with 10 to 19 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS20  IS 'number of firms with 20 to 49 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS50  IS 'number of firms with 50 to 99 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS100 IS 'number of firms with 100 to 199 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS200 IS 'number of firms with 200 to 499 employees in the town';
COMMENT ON COLUMN projekt.base_etablissement_par_tranche_effectif.E14TS500 IS 'number of firms with more than 500 employees in the town';

-- Searching for NULL values:

select *
from base_etablissement_par_tranche_effectif
where CODGEO  	is null or 
 	  LIBGEO  	is null or 
      REG     	is null or  
      DEP     	is null or  
      E14TST  	is null or 
      E14TS0ND	is null or 
      E14TS1  	is null or
      E14TS6    is null or
      E14TS10   is null or
      E14TS20   is null or
      E14TS50   is null or
      E14TS100  is null or
      E14TS200  is null or
      E14TS500  is null;
     
-- Searching for duplicates:
     
select 
	(select distinct 
		count(codgeo)
	from
		base_etablissement_par_tranche_effectif) as number_of_unique_rows,
	count(codgeo) as number_of_codgeo_numbers,
	count(distinct codgeo) as number_of_unique_codgeo_numbers
from
	base_etablissement_par_tranche_effectif;

-- There are nor NULL values and duplicates.
---------------------------------------------------------------------------------------

select count(distinct codgeo)
from population;
-- Result: 35 868

select count(distinct codgeo)
from net_salary_per_town_categories nsptc; 
-- Result: 5 013

select count(distinct codgeo)
from base_etablissement_par_tranche_effectif bepte; 
-- Result: 36 681 


-- The table with the key data for the analysis, net_salary_per_town_categories, contains earnings 
-- information for 5 013 different cities (after removing 125 records). The tables can be left as they 
-- are: when combining them with cities (CODGEO values) that are present in the net_salary_per_town_categories 
-- table, we need to use the LEFT JOIN function. In this way, we will only use the values present in both tables.


ALTER TABLE projekt.net_salary_per_town_categories RENAME TO salaries;
ALTER TABLE projekt.base_etablissement_par_tranche_effectif RENAME TO companies;
--------------------------------------------------------------------------------------------------------------------
