-- Analysis of companies in France:
create view companies_data as
select 
	g.*,
	codgeo,
	e14tst,
	e14ts0nd,
	e14ts1,
	e14ts6,
	e14ts10,
	e14ts20,
	e14ts50,
	e14ts100,
	e14ts200,
	e14ts500
from companies c
join( 
	select distinct
	g.code_région::numeric as region_code,
	g.nom_région as region_name
	from geography g  
	) g
on c.reg = g.region_code;

select * from companies_data

---Characteristic of companies by region:

--copy(

	with population_of_region as (
		select 
		codgeo, 
		sum(nb)::numeric as population
		from population_data pd
		group by codgeo)

	select 
		cd.region_name,
		sum(por.population) as population_region ,
		sum(e14tst) as total_number_of_companies,
		sum(e14ts0nd) as no_data,
		sum(e14ts1)   as up_to_5_employees,
		sum(e14ts6)   as up_to_9_employees,
		sum(e14ts10)  as up_to_19_employees,
		sum(e14ts20)  as up_to_49_employees,
		sum(e14ts50)  as up_to_99_employees,
		sum(e14ts100) as up_to_199_employees,
		sum(e14ts200) as up_to_499_employees,
		sum(e14ts500) as more_than_500_employees
	from companies_data cd
	join population_of_region por
	on cd.codgeo = por.codgeo
	group by cd.region_name

--	)
--to '[selected_directory]\companies_analysis.csv' 	delimiter ','  csv header;
