--select * from dbo.Data1;
--select * from dbo.Data2;

--number of rows in dataset
   select count(*) from dbo.Data1;
   select count(*) from dbo.Data2;

--dataset from bihar and jharkhand
    select * from dbo.Data1 
    where State='Bihar' or State='jharkhand'

    select * from dbo.Data2
    where State='Bihar' or State='jharkhand';

                              --INDIA
--1. Total population of India
     select SUM(population) Total_population from dbo.Data2
--2. Average growth of India
     select round(AVG(growth),4)*100 Average_growth_percentage from dbo.Data1;
--3. Sex ratio of India
  --Here sex ratio can't be determined directly by averaging the sex ratio of all
  --districts,because population hence weightage in mathematical formula would be different
  --Hence from available sex ratio of district total female population is determined
  --by finding no. of female per person then multiplying it with population of district
  --then summing it up giving total female population similarly for male population 1000/(ratio+1000)
  --gives male population and hence dividing gives sex ratio
         
       select
       round(1000*(sum(round((d1.Sex_Ratio/(d1.Sex_Ratio+1000))*d2.Population,0))/
      (sum(round((1000/(d1.Sex_Ratio+1000))*d2.Population,0)))),0)
       sex_ratio
       from dbo.Data1 d1 join dbo.Data2 d2  
       on d1.District=d2.District;
       
--4. Literacy Rate
-- For the similar reasons as Sex ratio we can't average and calculate Literacy rate of India
         select
         round((sum(d1.literacy*d2.Population/100)/
                sum(d2.Population))*100,2)
                  Literacy_rate
         from dbo.Data1 d1 join dbo.Data2 d2  
         on d1.District=d2.District;
		 
	                             --STATES
--1. Total Population of States
       select state, SUM(population) from dbo.Data2
	   group by state
--2. Average growth percentage
       select State,round(AVG(Growth),4)*100 average_growth from dbo.Data1
       group by State;
--3. Sex ratio of States 
       select d1.State,
       round(1000*(sum(round((d1.Sex_Ratio/(d1.Sex_Ratio+1000))*d2.Population,0))/
      (sum(round((1000/(d1.Sex_Ratio+1000))*d2.Population,0)))),0)
       sex_ratio
       from dbo.Data1 d1 join dbo.Data2 d2  
       on d1.District=d2.District
	   group by d1.State;
	   
--4. Literacy Rate of States
 
       select d1.State,
       round((sum(d1.literacy*d2.Population/100)/
              sum(d2.Population))*100,2)
                 Literacy_rate
       from dbo.Data1 d1 join dbo.Data2 d2  
           on d1.District=d2.District
	   group by d1.State;
		 
--5. Population density		 
        select d1.State, round(sum(d2.Population)/sum(d2.Area_km2),2) pop_density from dbo.Data2 d2
         join dbo.Data1 d1  
         on d1.District=d2.District
		 group by d1.State;
		 
--6. Top 3 district in each state based on literacy rate
		 select a.* from 
         (select District,State,Literacy, RANK() over(partition by state order by literacy desc) rnk from dbo.Data1) a
         where a.rnk in (1,2,3)
         group by State,District,Literacy,rnk
         order by rnk;
	  
	         select d1.District,d1.State,d1.Growth,d1.Literacy,d1.Sex_Ratio,d2.Area_km2,d2.Population
       from dbo.Data1 d1 join dbo.Data2 d2  
       on d1.District=d2.District
	   ;
	   
