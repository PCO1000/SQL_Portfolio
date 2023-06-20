/*
Title: COVID-19 Data Exploration Project
Data Analyst: Peace Okpala
Data Source: OurWorldinData (https://ourworldindata.org/covid-deaths)

Skills Utilized: CTE's, Converting Data Types, Joins, Temp Tables, Windows Functions, Aggregate Functions & Creating Views

*/

--Viewing all columns in the table and removing missing values
SELECT *
FROM CovidData..deaths
WHERE continent IS NOT NULL
ORDER BY 3,4


-- Selecting Initial Data from from Covid Deaths Table

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidData..deaths
WHERE continent IS NOT NULL 
ORDER BY 1,2


--What percentage of people died from the total number of Covid Cases in the United States?
--Formula (total_deaths/total_cases)*100

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidData..deaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1,2



--What percentage of the US Population has been infected with Covid-19?
--Formula (total_cases/population)*100

SELECT location, date, population, total_cases,  (total_cases/population)*100 AS PercentPopulationInfected
FROM CovidData..deaths
WHERE location like '%states%'
ORDER BY 1,2


-- What Countries have the Highest Infection Rate compared to Population?

SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidData..deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- What Countries have the Highest Death Count per Population?

SELECT location, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM CovidData..deaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC


-- Which Contintent has the highest death count per population?

SELECT continent, MAX(cast(Total_deaths as int)) AS TotalDeathCount
FROM CovidData..deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC



-- What is the Global Percentage of Death due to Covid-19?

SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM CovidData..deaths
WHERE continent IS NOT NULL 
ORDER BY 1,2

	
-- What Percentage of Population has recieved at least one Covid Vaccine?

SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY dea.Location ORDER BY dea.location, deaths.Date) AS RollingTotalVaccinated
FROM CovidData..deaths deaths
JOIN CovidData..vaccination vac 
	ON deaths.location = vac.location
	AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL
ORDER BY 2,3


-- Utilizing CTE to perform Calculation on Partition By in previous query

WITH Vaccinated (Continent, Location, Date, Population, New_Vaccinations, RollingTotalVaccinated)
AS
(
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY deaths.location ORDER BY deaths.location, deaths.Date) AS RollingTotalVaccinated
FROM CovidData..deaths deaths
JOIN CovidData..vaccination vac
	ON deaths.location = vac.location
	AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL 
)
SELECT *, (RollingTotalVaccinated/Population)*100
FROM Vaccinated



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #VaccinatedPercentage
CREATE TABLE #VaccinatedPercentage
(
Continent nvarchar(300),
Location nvarchar(300),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingTotalVaccinated numeric
)

INSERT INTO #VaccinatedPercentage
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY deaths.Location ORDER BY deaths.location, deaths.Date) AS RollingTotalVaccinated
FROM CovidData..deaths deaths
JOIN CovidData..vaccination vac
	ON deaths.location = vac.location
	AND deaths.date = vac.date

SELECT *, (RollingTotalVaccinated/Population)*100
FROM #VaccinatedPercentage



-- Creating View to store data for visualizations

CREATE VIEW PopulationVaccinated AS
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition BY deaths.Location ORDER BY deaths.location, deaths.Date) AS RollingPeopleVaccinated
FROM CovidData..deaths deaths
JOIN CovidData..vaccination vac
	ON deaths.location = vac.location
	AND deaths.date = vac.date
WHERE deaths.continent IS NOT NULL

CREATE VIEW GlobalDeaths AS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM CovidData..deaths
WHERE continent IS NOT NULL 
ORDER BY 1,2

CREATE VIEW InfectionRate AS
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidData..deaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC
