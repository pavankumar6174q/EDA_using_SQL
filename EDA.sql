#EXPLORATORY DATA ANALYSIS

select * from layoffs_staging2;

-- max layoffs in a single day 
select company, `date`, max(total_laid_off) 
from layoffs_staging2
group by company, `date`
order by 3 desc;

select * from layoffs_staging2;

-- companies that laid off 100% of staff
select company, total_laid_off, funds_raised_millions
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc;

select * 
from layoffs_staging2
where percentage_laid_off = 1;


-- total layoffs by companies from starting to ending dates
select company, sum(total_laid_off) as layoffs,
min(`date`) as start_date, max(`date`) as end_date,
datediff(max(`date`), min(`date`)) as layoffs_over_this_manyDays
from layoffs_staging2
group by 1
order by 2 desc;


-- the original date ranges in the data

select min(`date`) as start_date, max(`date`) as end_date  -- 2020-03-11st /// 2023-03-06end
from layoffs_staging2;


-- layoffs in industries

select industry, sum(total_laid_off) as layoffs
from layoffs_staging2
group by 1
order by 2 desc;

-- layoffs in countries

select country, sum(total_laid_off) as layoffs
from layoffs_staging2
group by 1
order by 2 desc;


-- layoffs by date

select `date`, sum(total_laid_off) as layoffs
from layoffs_staging2
group by 1
order by 1 desc;



-- layoffs by year

select Year(`date`), sum(total_laid_off) as layoffs
from layoffs_staging2
group by 1
order by 1 desc;



-- layoffs by month

select substring(`date`,1,7) as months, 
sum(total_laid_off) as layoffs
from layoffs_staging2
where substring(`date`,1,7) is not null
group by 1
order by 1;

-- Rolling total of layoffs by months

with rolling_total as (
select substring(`date`,1,7) as months,
sum(total_laid_off) as total_layoffs
from layoffs_staging2
where substring(`date`,1,7) is not null
group by 1
order by 1
)
select months, total_layoffs,
sum(total_layoffs) over(order by months) as rolling_total
from rolling_total;

-- How many layoffs by companies per year

select company, year(`date`) as year,
sum(total_laid_off) as layoffs
from layoffs_staging2
group by 1,2
order by 3 desc;


-- let's rank the top 5 companies as per layoffs and years

with company_layoffs(company, years, total_layoffs) as 
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by 1,2

),
company_rankings as
(select *,
dense_rank() over(partition by years order by total_layoffs desc ) as rankings
 from company_layoffs
 where years is not null)
select * from company_rankings
where rankings <= 5;


select company, industry, total_laid_off,
percentage_laid_off from layoffs_staging2
where total_laid_off is null;


-- Companies with most funding and their layoff count 

select company, country, sum(total_laid_off) as layoffs,
sum(funds_raised_millions) as funds_raised
from layoffs_staging2
group by 1,2
order by 4 desc;




