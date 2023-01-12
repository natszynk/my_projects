create view population_data as
select
	rg.region_code,
	rg.region_name,
	p.*
from population p
join(		select g.*,
			codgeo 
			from companies c
			join( 
				select distinct
				g.code_région::numeric as region_code,
				g.nom_région as region_name
				from geography g  
				) g
			on c.reg = g.region_code
		) rg
on p.codgeo = rg.codgeo
where p.codgeo in (select s.codgeo from salaries s);

-- Age and gender structure of poluation:

with age_gender_structure as (
	select 
	ageq80_17,
	sexe,
	sum(nb)::numeric as  population_of_the_group,
	(select sum(nb) from population_data pd)::numeric as total_population
	from population_data
	group by ageq80_17,sexe)

select 
	ageq80_17 as age_group,
	sexe,
	round(population_of_the_group/total_population*100,2) as contribution_of_the_group_in_population
from age_gender_structure;


-- Mean salary population:
select
round(avg(snhm14)::numeric,2) as mean_salary_popuation
from salaries_data sd; 

-- Correlation of mean salary with age and mean age with population of children by region:

create temp table corr_age_salary as
--copy(
	with mean_age_regions as (
		select
		ageq80_17 + 2.5 as mean_age,
		region_name,
		sum(nb)::numeric as  population_of_the_group
		from population_data
		group by ageq80_17, region_name)
		
	select 
	mag.region_name,
	round(sum(mean_age*population_of_the_group)/sum(population_of_the_group),2) as mean_age_by_region,
	round(avg(snhm14)::numeric,2) as mean_salary_by_region
	from mean_age_regions mag
	join salaries_data sd 
	on mag.region_name = sd.region_name 
	group by mag.region_name
--)
--to '[selected_directory]\mean_age_salary_region.csv' 	delimiter ','  csv header;

with population_region as(

	select
	pd.region_name,
	sum(pd.nb)::numeric as population_of_region,
	sum(
		case 
			when moco in (11, 12) and ageq80_17 in (0,5,10,15,20) then nb 
			else 0
		end)::numeric population_children
	from population_data pd
	group by pd.region_name
	)

select 
corr(mean_age_by_region,mean_salary_by_region),
corr((population_children/population_of_region),mean_age_by_region)
from corr_age_salary cas
join population_region pd 
on cas.region_name = pd.region_name;

-- Mean age total population (estimation):

with mean_age_population as (
	select
	ageq80_17 + 2.5 as mean_age,
	sum(nb)::numeric as  population_of_the_group
	from population_data
	group by ageq80_17)

select 
round(sum(mean_age*population_of_the_group)/sum(population_of_the_group),2) as mean_age
from mean_age_population ma

-- Mean age by region (estimation):

with mean_age_population_region as (
	select
		ageq80_17 + 2.5 as mean_age,
		region_name,
		sum(nb)::numeric as  population_of_the_group
	from population_data
	group by ageq80_17,region_name)

select 
	region_name,
	round(sum(mean_age*population_of_the_group)/sum(population_of_the_group),2) as mean_age_region
from mean_age_population_region mar
group by region_name


---Characteristic of cohabitation mode, sex and age:
--copy(
	with cohabitation_mode as (
		select 
			moco,
			ageq80_17,
			sexe,
			sum(nb)::numeric as  population_of_the_group,
			(select sum(nb) from population_data pd)::numeric as total_population
		from population_data
		group by moco, ageq80_17, sexe)

	select 
		moco,
		ageq80_17,
		sexe,
		round(population_of_the_group/total_population*100,2) as contribution_of_the_group_in_population
		from cohabitation_mode
-- )
--to '[selected_directory]\cohabitation_mode_sex_age.csv' 	delimiter ','  csv header;

