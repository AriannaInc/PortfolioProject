/* Select data to us
*/

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1,2


/* Looking at Total Cases vs Total Deaths in Europe
*/
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE continent LIKE '%Europe%'
ORDER BY 1,2

/* total cases vs population - shows what percentage of population got covid in Italy
*/
SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPercentage
FROM covid_deaths
WHERE location LIKE '%Italy%'
ORDER BY InfectedPercentage DESC


/* Countries with Highest Infection Rate compared to Population
*/
SELECT location, population, MAX(total_cases) AS HighestInfection, MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM covid_deaths
GROUP BY location, population
ORDER BY 4 DESC


/* Countries with Highest Death count per population. Plus, remove countries such as World, Europe, Asia and remove null values.
*/
SELECT location, MAX(CAST(total_deaths AS int)) AS HighestDeaths
FROM covid_deaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY location
ORDER BY HighestDeaths DESC

/* Break down by deaht count continent
*/
SELECT continent, MAX(CAST(total_deaths AS int)) AS HighestDeaths
FROM covid_deaths
WHERE continent IS NOT NULL AND total_deaths IS NOT NULL
GROUP BY continent
ORDER BY HighestDeaths DESC

/* What is the percentage of people with new cases dying?
*/
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT NULL AND new_deaths IS NOT NULL AND new_cases IS NOT NULL
ORDER BY 1,2

/* Join covid deaths and vaccination tables
*/
SELECT * FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location=vac.location AND dea.date=vac.date

/* What is the percentage of the population that got vaccinated globally
*/
SELECT dea.population, vac.people_vaccinated, SUM(vac.people_vaccinated)/SUM(dea.population)*100 AS PercentageVaccinatedPopulation FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location=vac.location AND dea.date=vac.date
GROUP BY dea.population, vac.people_vaccinated

/* What is the percentage of the population that got vaccinated by continent
*/
SELECT dea.continent, SUM(dea.population), SUM(vac.people_vaccinated), SUM(vac.people_vaccinated)/SUM(dea.population)*100 AS PercentageVaccinatedPopulation FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location=vac.location AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent
ORDER BY PercentageVaccinatedPopulation DESC

/* USE CTE to save the query
*/
WITH PopvsVac (continent, total_population, total_people_vaccinated, PercentageVaccinatedPopulation)
AS (
SELECT dea.continent, SUM(dea.population) AS total_population, SUM(vac.people_vaccinated) AS total_people_vaccinated, SUM(vac.people_vaccinated)/SUM(dea.population)*100 AS PercentageVaccinatedPopulation 
FROM covid_deaths dea
JOIN covid_vaccinations vac
ON dea.location=vac.location AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent
)

SELECT * FROM PopvsVac

