select * 
from PortfolioProjject..CovidDeaths
order by 3,4

--select * 
--from PortfolioProjject..CovidVaccinations
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjject..CovidDeaths
order by 1,2

select location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) as DeathPercent
from PortfolioProjject..CovidDeaths
where location like '%states%'
order by 1,2


select location, date, total_cases, population, round((total_cases/population)*100,2) as pop_covid_Percent
from PortfolioProjject..CovidDeaths
where location like '%States%'
order by 2,5

select location, population, date, MAX(total_cases) as HighestInfectedCount, round(MAX((total_cases/population))*100,2) as PercentPopInfected
from PortfolioProjject..CovidDeaths
group by location, population, date
order by PercentPopInfected desc


select continent, MAX(cast(total_deaths as int)) as HighestdeathCount, round(MAX((total_deaths/population))*100,2) as PercentPopDied
from PortfolioProjject..CovidDeaths
where continent is not null
group by continent
order by HighestdeathCount desc



select location, MAX(cast(total_deaths as int)) as HighestdeathCount, round(MAX((total_deaths/population))*100,2) as PercentPopDied
from PortfolioProjject..CovidDeaths
where continent is null
group by location
order by HighestdeathCount desc

select continent, MAX(cast(total_deaths as int)) as HighDeaths
from PortfolioProjject..CovidDeaths
where continent is not null
group by continent
order by HighDeaths desc

select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/ SUM(new_cases)*100 as DeathPercent
from PortfolioProjject..CovidDeaths
where continent is not null
--group by date
order by 1,2

select location, SUM(cast(new_deaths as int)) as TotalDeaths
from PortfolioProjject..CovidDeaths
where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by TotalDeaths desc

select *
from PortfolioProjject..CovidDeaths cd
	join PortfolioProjject..CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date


select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProjject..CovidDeaths cd
	join PortfolioProjject..CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
	where cd.continent is not null
order by 2,3

--Use CTE
With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinatied)
as(
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProjject..CovidDeaths cd
	join PortfolioProjject..CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
	where cd.continent is not null
)
Select *, RollingPeopleVaccinatied/population*100 from PopvsVac

--TEMP_Table
drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(250),
Location nvarchar(250),
Date Datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProjject..CovidDeaths cd
	join PortfolioProjject..CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
	where cd.continent is not null
Select *, (RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinated


create view PercentPopulationVaccinated as
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(convert(int,cv.new_vaccinations)) OVER (Partition by cv.location order by cd.location, cd.date) as RollingPeopleVaccinated
from PortfolioProjject..CovidDeaths cd
	join PortfolioProjject..CovidVaccinations cv 
	on cd.location = cv.location 
	and cd.date = cv.date
	where cd.continent is not null
	

	select * 
	from PercentPopulationVaccinated