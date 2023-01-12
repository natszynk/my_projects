-- Analysis of salaries - BY GENDER, REGION, AGE AND POSITION:
-- Initial data:

create view salaries_data as
select distinct
rg.region_code,
rg.region_name,
s.*
from salaries s
left join(	select g.*,
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
on s.codgeo = rg.codgeo

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

-- Mean age estimation:
create view mean_age_population_region as
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
group by region_name;

---- Median, interquartile range, MIN and MAX values for the country: woman vs. men:

	select 
		round(percentile_cont(0.5) within group (order by sd.snhm14)::numeric, 2) as median_salary_all,
		round(percentile_cont(0.5) within group (order by sd.snhmf14)::numeric, 2) as median_salary_women,
		round(percentile_cont(0.5) within group (order by sd.snhmh14)::numeric, 2) as median_salary_men,
		round(min(sd.snhm14)::numeric, 2)  as  min_salary_all,
		round(min(sd.snhmf14)::numeric, 2) as  min_salary_women,
		round(min(sd.snhmh14)::numeric, 2) as  min_salary_men,
		round(max(sd.snhm14)::numeric, 2)  as  max_salary_all,
		round(max(sd.snhmf14)::numeric, 2) as  max_salary_women,
		round(max(sd.snhmh14)::numeric, 2) as  max_salary_men,
		round(percentile_cont(0.75) within group (order by sd.snhm14)::numeric, 2) as q3_salary_all,
		round(percentile_cont(0.75) within group (order by sd.snhmf14)::numeric, 2) as q3_salary_women,
		round(percentile_cont(0.25) within group (order by sd.snhmh14)::numeric, 2) as q1_salary_men,
		round(percentile_cont(0.25) within group (order by sd.snhm14)::numeric, 2) as q1_salary_all,
		round(percentile_cont(0.25) within group (order by sd.snhmf14)::numeric, 2) as q1_salary_women,
		round(percentile_cont(0.75) within group (order by sd.snhmh14)::numeric, 2) as q3_salary_men,
		(select libgeo from salaries_data order by snhmh14 desc limit 1) as max_salary_men_commune,
		(select libgeo from salaries_data order by snhmf14 desc limit 1) as max_salary_women_commune,
		(select libgeo from salaries_data order by snhmh14 limit 1) as min_salary_men_commune,
		(select libgeo from salaries_data order by snhmf14 limit 1) as min_salary_women_commune
from salaries_data sd;


---- Median, interquartile range, MIN and MAX values per region: woman vs. men:
--copy(
	select
		region_name, 
		round(percentile_cont(0.5) within group (order by sd.snhm14)::numeric, 2) as median_salary_all,
		round(percentile_cont(0.5) within group (order by sd.snhmf14)::numeric, 2) as median_salary_women,
		round(percentile_cont(0.5) within group (order by sd.snhmh14)::numeric, 2) as median_salary_men,
		round(min(sd.snhm14)::numeric, 2)  as  min_salary_all,
		round(min(sd.snhmf14)::numeric, 2) as  min_salary_women,
		round(min(sd.snhmh14)::numeric, 2) as  min_salary_men,
		round(max(sd.snhm14)::numeric, 2)  as  max_salary_all,
		round(max(sd.snhmf14)::numeric, 2) as  max_salary_women,
		round(max(sd.snhmh14)::numeric, 2) as  max_salary_men,
		round(percentile_cont(0.75) within group (order by sd.snhm14)::numeric, 2) as q3_salary_all,
		round(percentile_cont(0.75) within group (order by sd.snhmf14)::numeric, 2) as q3_salary_women,
		round(percentile_cont(0.25) within group (order by sd.snhmh14)::numeric, 2) as q1_salary_men,
		round(percentile_cont(0.25) within group (order by sd.snhm14)::numeric, 2) as q1_salary_all,
		round(percentile_cont(0.25) within group (order by sd.snhmf14)::numeric, 2) as q1_salary_women,
		round(percentile_cont(0.75) within group (order by sd.snhmh14)::numeric, 2) as q3_salary_men
	from salaries_data sd
	group by region_name
--	)
--to '[selected_directory]\gender_salary_max_min_regions.csv' 	delimiter ','  csv header;
	

-- Salaries by gender and communes:
--copy(
	select
		region_name,
		libgeo, 
		sd.snhm14 as salary_all,
		sd.snhmf14 as salary_women,
		sd.snhmh14 as salary_men
	from salaries_data sd
--	)
--to '[selected_directory]\gender_salary_communes.csv' 	delimiter ','  csv header;
	
	
-- Extracting information on communes in which salaries for a given group are max or min:

		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by snhmh14 desc limit 1) 
		
		union
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by snhmf14 desc limit 1)
		
		union
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by snhmh14 limit 1)
		
		union
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by snhmf14 limit 1))

	

---- Median, difference of medians and interquartile range by region: woman vs. men:

--copy(
with region_data as(
	select 
		sd.region_name,
		round(percentile_cont(0.5) within group (order by sd.snhm14)::numeric, 2) as median_salary_all,
		round(percentile_cont(0.5) within group (order by sd.snhmf14)::numeric, 2) as median_salary_women,
		round(percentile_cont(0.5) within group (order by sd.snhmh14)::numeric, 2) as median_salary_men,
		round(percentile_cont(0.5) within group (order by sd.snhmf14)::numeric, 2) - 
		round(percentile_cont(0.5) within group (order by sd.snhmh14)::numeric, 2) as diff_median_women_men,
		round(percentile_cont(0.75) within group (order by sd.snhm14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.snhm14)::numeric, 2) as iqr_salary_all,
		round(percentile_cont(0.75) within group (order by sd.snhmf14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.snhmf14)::numeric, 2) as iqr_salary_women,
		round(percentile_cont(0.75) within group (order by sd.snhmh14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.snhmh14)::numeric, 2) as iqr_salary_men
	from salaries_data sd
	group by region_name
	),
	
population_region as(

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
--rd.*,
--round(pd.population_children/pd.population_of_region*100::numeric,2) percentage_of_children,
--mapr.mean_age_region as mean_age
corr(median_salary_all,abs(diff_median_women_men)),
corr(iqr_salary_all,abs(diff_median_women_men)),
corr(median_salary_women,median_salary_men),
corr(median_salary_women,median_salary_all),
corr(median_salary_women,(population_children/population_of_region)),
corr(iqr_salary_women,(population_children/population_of_region)),
corr(abs(diff_median_women_men),(population_children/population_of_region)),
corr(abs(diff_median_women_men),mean_age_region)
from region_data rd
join population_region pd 
on rd.region_name = pd.region_name 
join mean_age_population_region mapr
on pd.region_name = mapr.region_name
--)
--to '[selected_directory]\gender_salary_regions.csv' 	delimiter ','  csv header;

--------------------------------------------------------------------------------------------------------------------------------------

---- Median, MIN, MAX and Q1 and Q3 by position for the contry: woman vs. men:

	select 
		round(percentile_cont(0.5) within group (order by sd.SNHMC14)::numeric, 2) as median_salary_all_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMP14)::numeric, 2) as median_salary_all_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHME14)::numeric, 2) as median_salary_all_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMO14)::numeric, 2) as median_salary_all_worker,
		round(percentile_cont(0.5) within group (order by sd.SNHMHC14)::numeric, 2) as median_salary_men_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMHP14)::numeric, 2) as median_salary_men_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHMHE14)::numeric, 2) as median_salary_men_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMHO14)::numeric, 2) as median_salary_men_worker,
		round(percentile_cont(0.5) within group (order by sd.SNHMFC14)::numeric, 2) as median_salary_women_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMFP14)::numeric, 2) as median_salary_women_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHMFE14)::numeric, 2) as median_salary_women_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMFO14)::numeric, 2) as median_salary_women_worker,
		
		round(min(sd.SNHMC14)::numeric, 2) as min_salary_all_executive,
		round(min(sd.SNHMP14)::numeric, 2) as min_salary_all_middle_manager,
		round(min(sd.SNHME14)::numeric, 2) as min_salary_all_employee,
		round(min(sd.SNHMO14)::numeric, 2) as min_salary_all_worker,
		round(min(sd.SNHMHC14)::numeric, 2) as min_salary_men_executive,
		round(min(sd.SNHMHP14)::numeric, 2) as min_salary_men_middle_manager,
		round(min(sd.SNHMHE14)::numeric, 2) as min_salary_men_employee,
		round(min(sd.SNHMHO14)::numeric, 2) as min_salary_men_worker,
		round(min(sd.SNHMFC14)::numeric, 2) as min_salary_women_executive,
		round(min(sd.SNHMFP14)::numeric, 2) as min_salary_women_middle_manager,
		round(min(sd.SNHMFE14)::numeric, 2) as min_salary_women_employee,
		round(min(sd.SNHMFO14)::numeric, 2) as min_salary_women_worker,
		
		round(max(sd.SNHMC14)::numeric, 2) as max_salary_all_executive,
		round(max(sd.SNHMP14)::numeric, 2) as max_salary_all_middle_manager,
		round(max(sd.SNHME14)::numeric, 2) as max_salary_all_employee,
		round(max(sd.SNHMO14)::numeric, 2) as max_salary_all_worker,
		round(max(sd.SNHMHC14)::numeric, 2) as max_salary_men_executive,
		round(max(sd.SNHMHP14)::numeric, 2) as max_salary_men_middle_manager,
		round(max(sd.SNHMHE14)::numeric, 2) as max_salary_men_employee,
		round(max(sd.SNHMHO14)::numeric, 2) as max_salary_men_worker,
		round(max(sd.SNHMFC14)::numeric, 2) as max_salary_women_executive,
		round(max(sd.SNHMFP14)::numeric, 2) as max_salary_women_middle_manager,
		round(max(sd.SNHMFE14)::numeric, 2) as max_salary_women_employee,
		round(max(sd.SNHMFO14)::numeric, 2) as max_salary_women_worker,
		
		round(percentile_cont(0.75) within group (order by sd.SNHMC14)::numeric, 2) as  q3_salary_all_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMP14)::numeric, 2) as  q3_salary_all_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHME14)::numeric, 2) as  q3_salary_all_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMO14)::numeric, 2) as  q3_salary_all_worker,
		round(percentile_cont(0.75) within group (order by sd.SNHMHC14)::numeric, 2) as q3_salary_men_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMHP14)::numeric, 2) as q3_salary_men_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHMHE14)::numeric, 2) as q3_salary_men_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMHO14)::numeric, 2) as q3_salary_men_worker,
		round(percentile_cont(0.75) within group (order by sd.SNHMFC14)::numeric, 2) as q3_salary_women_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMFP14)::numeric, 2) as q3_salary_women_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHMFE14)::numeric, 2) as q3_salary_women_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMFO14)::numeric, 2) as q3_salary_women_worker,
		
		round(percentile_cont(0.25) within group (order by sd.SNHMC14)::numeric, 2) as  q1_salary_all_executive,
        round(percentile_cont(0.25) within group (order by sd.SNHMP14)::numeric, 2) as  q1_salary_all_middle_manager,
		round(percentile_cont(0.25) within group (order by sd.SNHME14)::numeric, 2) as  q1_salary_all_employee,
        round(percentile_cont(0.25) within group (order by sd.SNHMO14)::numeric, 2) as  q1_salary_all_worker,
		round(percentile_cont(0.25) within group (order by sd.SNHMHC14)::numeric, 2) as q1_salary_men_executive,		
        round(percentile_cont(0.25) within group (order by sd.SNHMHP14)::numeric, 2) as q1_salary_men_middle_manager,
        round(percentile_cont(0.25) within group (order by sd.SNHMHE14)::numeric, 2) as q1_salary_men_employee,
        round(percentile_cont(0.25) within group (order by sd.SNHMHO14)::numeric, 2) as q1_salary_men_worker,
        round(percentile_cont(0.25) within group (order by sd.SNHMFC14)::numeric, 2) as q1_salary_women_executive,
        round(percentile_cont(0.25) within group (order by sd.SNHMFP14)::numeric, 2) as q1_salary_women_middle_manager,
        round(percentile_cont(0.25) within group (order by sd.SNHMFE14)::numeric, 2) as q1_salary_women_employee,
        round(percentile_cont(0.25) within group (order by sd.SNHMFO14)::numeric, 2) as q1_salary_women_worker
	from salaries_data sd;

---- Salaries by commune, gender and position:

--copy(
	select
		sd.region_name,
		sd.libgeo as commune,
		sd.SNHMC14  as salary_all_executive,
		sd.SNHMP14  as salary_all_middle_manager,
		sd.SNHME14  as salary_all_employee,
		sd.SNHMO14  as salary_all_worker,
		sd.SNHMHC14 as salary_men_executive,
		sd.SNHMHP14 as salary_men_middle_manager,
		sd.SNHMHE14 as salary_men_employee,
		sd.SNHMHO14 as salary_men_worker,
		sd.SNHMFC14 as salary_women_executive,
		sd.SNHMFP14 as salary_women_middle_manager,
		sd.SNHMFE14 as salary_women_employee,
		sd.SNHMFO14 as salary_women_worker
	from salaries_data sd
--	)
--to '[selected_directory]\gender_salary_position_communes.csv' 	delimiter ','  csv header;

-- Extracting information on communes in which salaries for a given groups are max or min:

		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHC14 desc limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFC14 desc limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHP14 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFP14 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHE14 desc limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFE14 desc limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHO14 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFO14 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHC14 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFC14 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHP14 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFP14 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHE14 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFE14 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMHO14 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMFO14 limit 1);



---- Median, MIN, MAX and IQR by region and position; woman vs. men:
--copy(
with region_data as(
	select 
		sd.region_name,
		round(percentile_cont(0.5) within group (order by sd.SNHMC14)::numeric, 2) as median_salary_all_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMP14)::numeric, 2) as median_salary_all_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHME14)::numeric, 2) as median_salary_all_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMO14)::numeric, 2) as median_salary_all_worker,
		round(percentile_cont(0.5) within group (order by sd.SNHMHC14)::numeric, 2) as median_salary_men_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMHP14)::numeric, 2) as median_salary_men_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHMHE14)::numeric, 2) as median_salary_men_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMHO14)::numeric, 2) as median_salary_men_worker,
		round(percentile_cont(0.5) within group (order by sd.SNHMFC14)::numeric, 2) as median_salary_women_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMFP14)::numeric, 2) as median_salary_women_middle_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHMFE14)::numeric, 2) as median_salary_women_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMFO14)::numeric, 2) as median_salary_women_worker,
		
		round(percentile_cont(0.75) within group (order by sd.SNHMC14)::numeric, 2)  -
		round(percentile_cont(0.25) within group (order by sd.SNHMC14)::numeric, 2) as IQR_salary_all_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMP14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMP14)::numeric, 2) as IQR_salary_all_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHME14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHME14)::numeric, 2) as IQR_salary_all_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMO14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMO14)::numeric, 2) as IQR_salary_all_worker,
		round(percentile_cont(0.75) within group (order by sd.SNHMHC14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMHC14)::numeric, 2) as IQR_salary_men_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMHP14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMHP14)::numeric, 2) as IQR_salary_men_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHMHE14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMHE14)::numeric, 2) as IQR_salary_men_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMHO14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMHO14)::numeric, 2) as IQR_salary_men_worker,
		round(percentile_cont(0.75) within group (order by sd.SNHMFC14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMFC14)::numeric, 2) as IQR_salary_women_executive,
		round(percentile_cont(0.75) within group (order by sd.SNHMFP14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMFP14)::numeric, 2) as IQR_salary_women_middle_manager,
		round(percentile_cont(0.75) within group (order by sd.SNHMFE14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMFE14)::numeric, 2) as IQR_salary_women_employee,
		round(percentile_cont(0.75) within group (order by sd.SNHMFO14)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMFO14)::numeric, 2) as IQR_salary_women_worker,
		
		round(percentile_cont(0.5) within group (order by sd.SNHMFC14)::numeric, 2) - 
		round(percentile_cont(0.5) within group (order by sd.SNHMHC14)::numeric, 2) as diff_median_women_men_executive,
		round(percentile_cont(0.5) within group (order by sd.SNHMFP14)::numeric, 2) - 
		round(percentile_cont(0.5) within group (order by sd.SNHMHP14)::numeric, 2) as diff_median_women_men_manager,
		round(percentile_cont(0.5) within group (order by sd.SNHMFE14)::numeric, 2) - 
		round(percentile_cont(0.5) within group (order by sd.SNHMHE14)::numeric, 2) as diff_median_women_men_employee,
		round(percentile_cont(0.5) within group (order by sd.SNHMFO14)::numeric, 2) - 
		round(percentile_cont(0.5) within group (order by sd.SNHMHO14)::numeric, 2) as diff_median_women_men_worker
	from salaries_data sd
	group by region_name
	),
	
population_region as(

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
--rd.*,
--round(pd.population_children/pd.population_of_region*100::numeric,2) percentage_of_children,
--mapr.mean_age_region as mean_age
corr(IQR_salary_women_executive,(population_children/population_of_region)),
corr(IQR_salary_men_executive,(population_children/population_of_region)),
corr(abs(diff_median_women_men_executive),(population_children/population_of_region)),
corr(abs(diff_median_women_men_executive),mean_age_region)
from region_data rd
join population_region pd 
on rd.region_name = pd.region_name
join mean_age_population_region mapr
on pd.region_name = mapr.region_name
--)
--to '[selected_directory]\regions_gender_and_position.csv' 	delimiter ','  csv header;

--------------------------------------------------------------------------------------------------------------------------

---- Median, MIN, MAX and Q1 and Q3 by age for the country; woman vs. men:

	select 
		round(percentile_cont(0.5) within group (order by sd.SNHM1814 )::numeric, 2)  as  median_salary_all_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHM2614 )::numeric, 2)  as  median_salary_all_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHM5014 )::numeric, 2)  as  median_salary_all_above_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMF1814)::numeric, 2) as median_salary_women_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHMF2614)::numeric, 2) as median_salary_women_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMF5014)::numeric, 2) as median_salary_women_above_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMH1814)::numeric, 2) as median_salary_men_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHMH2614)::numeric, 2) as median_salary_men_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMH5014)::numeric, 2) as median_salary_men_above_50,

		round(min(sd.SNHM1814) ::numeric, 2)  as min_salary_all_18_25,
		round(min(sd.SNHM2614) ::numeric, 2)  as min_salary_all_25_50,
		round(min(sd.SNHM5014) ::numeric, 2)  as min_salary_all_above_50,
		round(min(sd.SNHMF1814)::numeric, 2)  as min_salary_women_18_25,
		round(min(sd.SNHMF2614)::numeric, 2) as min_salary_women_25_50,
		round(min(sd.SNHMF5014)::numeric, 2) as min_salary_women_above_50,
		round(min(sd.SNHMH1814)::numeric, 2) as min_salary_men_18_25,
		round(min(sd.SNHMH2614)::numeric, 2) as min_salary_men_25_50,
		round(min(sd.SNHMH5014)::numeric, 2) as min_salary_men_above_50,

		
		round(max(sd.SNHM1814 ) ::numeric, 2)  as max_salary_all_18_25,
		round(max(sd.SNHM2614 ) ::numeric, 2)  as max_salary_all_25_50,
		round(max(sd.SNHM5014 ) ::numeric, 2)  as max_salary_all_above_50,
		round(max(sd.SNHMF1814)::numeric, 2)  as max_salary_women_18_25,
		round(max(sd.SNHMF2614)::numeric, 2) as max_salary_women_25_50,
		round(max(sd.SNHMF5014)::numeric, 2) as max_salary_women_above_50,
		round(max(sd.SNHMH1814)::numeric, 2) as max_salary_men_18_25,
		round(max(sd.SNHMH2614)::numeric, 2) as max_salary_men_25_50,
		round(max(sd.SNHMH5014)::numeric, 2) as max_salary_men_above_50,
		
		round(percentile_cont(0.75) within group (order by sd.SNHM1814) ::numeric, 2) as  q3_salary_all_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHM2614) ::numeric, 2) as  q3_salary_all_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHM5014) ::numeric, 2) as  q3_salary_all_above_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMF1814)::numeric, 2) as  q3_salary_women_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHMF2614)::numeric, 2) as q3_salary_women_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMF5014)::numeric, 2) as q3_salary_women_above_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMH1814)::numeric, 2) as q3_salary_men_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHMH2614)::numeric, 2) as q3_salary_men_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMH5014)::numeric, 2) as q3_salary_men_above_50,

		round(percentile_cont(0.25) within group (order by sd.SNHM1814) ::numeric, 2) as  q1_salary_all_18_25,
        round(percentile_cont(0.25) within group (order by sd.SNHM2614) ::numeric, 2) as  q1_salary_all_25_50,
		round(percentile_cont(0.25) within group (order by sd.SNHM5014) ::numeric, 2) as  q1_salary_all_above_50,
        round(percentile_cont(0.25) within group (order by sd.SNHMF1814)::numeric, 2) as  q1_salary_women_18_25,
		round(percentile_cont(0.25) within group (order by sd.SNHMF2614)::numeric, 2) as q1_salary_women_25_50,
        round(percentile_cont(0.25) within group (order by sd.SNHMF5014)::numeric, 2) as q1_salary_women_above_50,
        round(percentile_cont(0.25) within group (order by sd.SNHMH1814)::numeric, 2) as q1_salary_men_18_25,
        round(percentile_cont(0.25) within group (order by sd.SNHMH2614)::numeric, 2) as q1_salary_men_25_50,
        round(percentile_cont(0.25) within group (order by sd.SNHMH5014)::numeric, 2) as q1_salary_men_above_50
	from salaries_data sd;


---- Salaries by commune, gender and position:

--copy(
	select
		sd.region_name,
		sd.libgeo as commune,
		sd.SNHM1814  as salary_all_18_25,
		sd.SNHM2614  as salary_all_25_50,
		sd.SNHM5014  as salary_all_above_50,
		sd.SNHMF1814 as salary_women_18_25,
		sd.SNHMF2614 as salary_women_25_50,
		sd.SNHMF5014 as salary_women_above_50,
		sd.SNHMH1814 as salary_men_18_25,
		sd.SNHMH2614 as salary_men_25_50,
		sd.SNHMH5014 as salary_men_above_50
	from salaries_data sd
--	)
--to '[selected_directory]\gender_salary_age_communes.csv' 	delimiter ','  csv header;


-- Extracting information on communes in which salaries for a given groups are max or min:

		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF1814 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF2614 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF5014 desc limit 1) 
		
		union all
		
		(select libgeo , region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH1814 desc limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH2614 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH5014 desc limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF1814 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF2614 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMF5014 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH1814 limit 1) 
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH2614 limit 1)
		
		union all
		
		(select libgeo, region_name, g.latitude, g.longitude 
		from salaries_data sd
		join geography g
		on sd.codgeo = g.code_insee
		order by SNHMH5014 limit 1);
		

---- Median, MIN, MAX and IQR by region and age; woman vs. men:

--copy(
with region_data as(
	select 
		sd.region_name,
		round(percentile_cont(0.5) within group (order by sd.snhm14)::numeric, 2) as median_salary_all,
		round(percentile_cont(0.5) within group (order by sd.SNHM1814 )::numeric, 2)  as  median_salary_all_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHM2614 )::numeric, 2)  as  median_salary_all_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHM5014 )::numeric, 2)  as  median_salary_all_above_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMF1814)::numeric, 2)  as  median_salary_women_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHMF2614)::numeric, 2)  as  median_salary_women_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMF5014)::numeric, 2)  as  median_salary_women_above_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMH1814)::numeric, 2)  as  median_salary_men_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHMH2614)::numeric, 2)  as  median_salary_men_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMH5014)::numeric, 2)  as  median_salary_men_above_50,

		
		round(percentile_cont(0.75) within group (order by sd.SNHM1814) ::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHM1814) ::numeric, 2) as  iqr_salary_all_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHM2614) ::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHM2614) ::numeric, 2) as  iqr_salary_all_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHM5014) ::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHM5014) ::numeric, 2) as  iqr_salary_all_above_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMF1814)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMF1814)::numeric, 2) as  iqr_salary_women_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHMF2614)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMF2614)::numeric, 2) as iqr_salary_women_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMF5014)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMF5014)::numeric, 2) as iqr_salary_women_above_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMH1814)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMH1814)::numeric, 2) as iqr_salary_men_18_25,
		round(percentile_cont(0.75) within group (order by sd.SNHMH2614)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMH2614)::numeric, 2) as iqr_salary_men_25_50,
		round(percentile_cont(0.75) within group (order by sd.SNHMH5014)::numeric, 2) -
		round(percentile_cont(0.25) within group (order by sd.SNHMH5014)::numeric, 2) as iqr_salary_men_above_50,

		round(percentile_cont(0.5) within group (order by sd.SNHMF1814)::numeric, 2)  -
		round(percentile_cont(0.5) within group (order by sd.SNHMH1814)::numeric, 2)  as  diff_median_salary_men_women_18_25,
		round(percentile_cont(0.5) within group (order by sd.SNHMF2614)::numeric, 2)  -
		round(percentile_cont(0.5) within group (order by sd.SNHMH2614)::numeric, 2)  as  diff_median_salary_men_women_25_50,
		round(percentile_cont(0.5) within group (order by sd.SNHMF5014)::numeric, 2)  -
		round(percentile_cont(0.5) within group (order by sd.SNHMH5014)::numeric, 2)  as  diff_median_salary_men_women_above_50
	from salaries_data sd
	group by region_name
	),
	
population_region as(

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
--rd.*,
--round(pd.population_children/pd.population_of_region*100::numeric,2) percentage_of_children,
--mapr.mean_age_region as mean_age
corr(abs(diff_median_salary_men_women_above_50),mean_age_region),
corr(abs(diff_median_salary_men_women_above_50),median_salary_all),
corr(abs(diff_median_salary_men_women_25_50),mean_age_region),
corr(abs(diff_median_salary_men_women_18_25),mean_age_region),
corr(abs(diff_median_salary_men_women_above_50),(population_children/population_of_region)),
corr(abs(diff_median_salary_men_women_25_50),(population_children/population_of_region)),
corr(abs(diff_median_salary_men_women_18_25),(population_children/population_of_region)),
corr(abs(iqr_salary_women_above_50),(population_children/population_of_region)),
corr(abs(iqr_salary_women_25_50),(population_children/population_of_region)),
corr(abs(iqr_salary_men_18_25),(population_children/population_of_region)),
corr(abs(iqr_salary_men_above_50),(population_children/population_of_region)),
corr(abs(iqr_salary_men_25_50),(population_children/population_of_region)),
corr(abs(iqr_salary_men_18_25),(population_children/population_of_region))
from region_data rd
join population_region pd 
on rd.region_name = pd.region_name
join mean_age_population_region mapr
on pd.region_name = mapr.region_name
--)
--to '[selected_directory]\regions_gender_and_age.csv' 	delimiter ','  csv header;



--------------------------------------------------------------------------------------------------------
-- Location of the capitals for each region:

ALTER TABLE projekt.geography RENAME COLUMN "chef.lieu_région" to chef_lieu_région;

--location of capitals:

--copy(
	select distinct
	g.code_région, 
	g.chef_lieu_région,
	g.latitude,
	g.longitude
	from geography g
	where lower(g.chef_lieu_région) = lower(g.nom_commune)
	)
--to '[selected_directory]\capitals.csv' 	delimiter ','  csv header;

-- Information for the map of France divided by regions:

--copy(
	select distinct
	g.code_région, 
	g.nom_région,
	g.numéro_département,
	g.nom_département
	from geography g
	order by g.numéro_département
--	)
--to '[selected_directory]\geography.csv' 	delimiter ','  csv header;
------------------------------------------------------------------------------------------------------------


