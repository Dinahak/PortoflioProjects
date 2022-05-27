SELECT*
FROM PortfolioProject1..CovidDeaths$
ORDER BY 3,4
--SELECT*
--FROM PortfolioProject1..CovidVaccinations$
--ORDER BY 3,4

--SELECT DATA WE ARE GOING TO BE USING 
SELECT location ,population ,total_cases , new_cases ,total_deaths 
FROM PortfolioProject1..CovidDeaths$
ORDER BY 1,2

--LOOKING AT TOTAL CASES VS TOTAL DEATHS
SELECT location ,total_cases , date ,total_deaths ,(total_deaths/total_cases)*100 as DEATH_PERCENTAGE 
FROM PortfolioProject1..CovidDeaths$
WHERE location like '%kenya%'
ORDER BY 1,2
--LOOKING AT TOTAL CASES VS population 
SELECT location ,total_cases , date ,population ,(total_cases/population)*100 as INFECTED_PERCENTAGE 
FROM PortfolioProject1..CovidDeaths$
WHERE location like '%kenya%'
ORDER BY 1,2
--looking at countries highest infection rate compared to population
SELECT location, population , MAX (total_cases) as HIGHEST_INFECTION_COUNT ,MAX ((total_cases/population))*100 as INFECTED_PERCENTAGE 
FROM PortfolioProject1..CovidDeaths$
GROUP BY population,location
ORDER BY INFECTED_PERCENTAGE desc

----showing continents with the highest death count per population 
SELECT location, MAX(cast(total_deaths as INT))as totaldeathcount
from PortfolioProject1..CovidDeaths$
where continent IS NOT NULL
GROUP BY location	
ORDER BY totaldeathcount desc

----breakdown everything by continents
SELECT continent, MAX(cast(total_deaths as INT))as totaldeathcount
from PortfolioProject1..CovidDeaths$
where continent IS NOT NULL
GROUP BY continent	
ORDER BY totaldeathcount desc

--showing continents with highest death count

SELECT continent, MAX(cast(total_deaths as INT))as totaldeathcount
from PortfolioProject1..CovidDeaths$
where continent IS NOT NULL
GROUP BY continent	
ORDER BY totaldeathcount desc

--global numbers 
SELECT SUM(new_cases ),SUM(cast(new_deaths as INT)) ,SUM(cast(new_deaths as INT))/SUM(new_cases )*100 as DEATH_PERCENTAGE 
FROM PortfolioProject1..CovidDeaths$
--WHERE location like '%kenya%'
where continent IS NOT NULL

ORDER BY 1,2

-- covid vaccination table  // joined tables 

select*
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date

--looking at total population VS vaccination 
select dea.continent ,dea.location , dea.date ,dea.population ,vac.new_vaccinations 
,SUM(CONVERT (int,vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location ,dea.date )as RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent IS NOT NULL
order by 2,3


--using CTE
With PopvsVac (Continent, Location , Date , Population ,New_vaccinations , RollingPeopleVaccinated )
as
(
select dea.continent ,dea.location , dea.date ,dea.population ,vac.new_vaccinations 
,SUM(CONVERT (int,vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location ,dea.date )as RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select* ,(RollingPeopleVaccinated /Population )*100
FROM PopvsVac

--using a temp table 
Create table #PercentpopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
Insert into #PercentpopulationVaccinated
Select dea.continent ,dea.location , dea.date ,dea.population ,vac.new_vaccinations 
,SUM(CONVERT (int,vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location ,dea.date )as RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select* ,(RollingPeopleVaccinated /Population )*100
FROM #PercentpopulationVaccinated

--creating view to store data for data viz
Create View PercentpopulationVaccinated as
Select dea.continent ,dea.location , dea.date ,dea.population ,vac.new_vaccinations 
,SUM(CONVERT (int,vac.new_vaccinations )) OVER (Partition by dea.location ORDER BY dea.location ,dea.date )as RollingPeopleVaccinated
from PortfolioProject1..CovidDeaths$ dea
join PortfolioProject1..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3