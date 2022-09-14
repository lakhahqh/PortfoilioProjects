Select *
From PortfolioProject..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations$
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Show the likelihood of dying if you contract to Covid-19 in Vietnam
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate
From PortfolioProject..CovidDeaths$
Where location like '%vietnam%'
order by 1,2

-- Looking at Total Cases vs Population
-- Show what percentage of population got Covid
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionRates
From PortfolioProject..CovidDeaths$
Where location like '%vietnam%'
order by 1,2

-- Looking at Countries with Highest Infection Rates compared to  Population
Select Location, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group by location, population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Coung
Select Location, max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by location
Order by HighestDeathCount desc


-- Showing Countries with Highest Death Count per Population
Select Location, max(cast(total_deaths as int)) as HighestDeathCount, max(cast(total_deaths as int)/population)*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by location
Order by PercentPopulationDeath desc


-- Break things down by continent
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
Order by HighestDeathCount desc

-- Showing continents with the highest death count per population
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by continent
Order by HighestDeathCount desc

-- Global numbers
Select date, sum(new_cases) as total_case, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
Group by date
Order by 1,2

-- Death Percentage on global scale
Select sum(new_cases) as total_case, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
Where continent is not null
-- Group by date
Order by 1,2

-- Looking at Total Population and  Vaccinations
-- Use CTE
With PopVsVac (continent, location, date, population, new_vaccinations, cumulative_vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location
												ORDER BY dea.location, dea.date) as cumulative_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.date = vac.date
	and dea.location = vac.location
Where dea.continent is not null 
Order by 2,3
)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location
												ORDER BY dea.location, dea.date) as cumulative_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.date = vac.date
	and dea.location = vac.location
Where dea.continent is not null 
Order by 2,3