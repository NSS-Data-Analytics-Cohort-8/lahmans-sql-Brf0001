-- ## Lahman Baseball Database Exercise
-- - this data has been made available [online](http://www.seanlahman.com/baseball-archive/statistics/) by Sean Lahman
-- - you can find a data dictionary [here](http://www.seanlahman.com/files/database/readme2016.txt)

-- ### Use SQL queries to find answers to the *Initial Questions*. If time permits, choose one (or more) of the *Open-Ended Questions*. Toward the end of the bootcamp, we will revisit this data if time allows to combine SQL, Excel Power Pivot, and/or Python to answer more of the *Open-Ended Questions*.



-- **Initial Questions**

-- 1. What range of years for baseball games played does the provided database cover? 

	SELECT MAX(yearid), MIN(yearid)
	FROM teams

	--ANSWER: 1871 through 2016
	
-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
   
   SELECT namefirst, namelast, height
   FROM people
   WHERE height = 
   		(
		SELECT MIN(height)
		FROM people
		)
		
	--ANSWER: "Eddie"	"Gaedel"	43		
   

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?
	
	SELECT p.namefirst, p.namelast, SUM(sal.salary) AS tot_sal
	FROM people AS p
	INNER JOIN collegeplaying USING(playerid)
	INNER JOIN salaries AS sal USING(playerid)
	WHERE schoolid = 
			(
			SELECT schoolid
			FROM schools
			WHERE schoolname LIKE '%Vanderbilt%'
			)
	GROUP BY playerid
	ORDER BY tot_sal DESC

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
   
   SELECT
   	CASE WHEN pos = 'OF' THEN 'Outfield'
		WHEN pos = 'SS' OR pos = '1B' OR pos = '2B' OR pos = '3B' THEN 'Infield'
		WHEN pos = 'P' OR pos = 'C' THEN 'Battery'
		ELSE 'Idk' END AS posti,
	SUM(po) AS putouts
   FROM fielding
   WHERE yearid = 2016
   GROUP BY posti
   
-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?
   
   SELECT *
   FROM batting
	
  		SELECT
	  CASE WHEN yearid >= 1920 AND yearid <= 1929 THEN '20s'
		WHEN yearid >= 1930 AND yearid <= 1939 THEN '30s'
		WHEN yearid >= 1940 AND yearid <= 1949 THEN '40s'
		WHEN yearid >= 1950 AND yearid <= 1959 THEN '50s'
		WHEN yearid >= 1960 AND yearid <= 1969 THEN '60s'
		WHEN yearid >= 1970 AND yearid <= 1979 THEN '70s'
		WHEN yearid >= 1980 AND yearid <= 1989 THEN '80s'
		WHEN yearid >= 1990 AND yearid <= 1999 THEN '90s'
		WHEN yearid >= 2000 AND yearid <= 2009 THEN '00s'
		WHEN yearid >= 2010 AND yearid <= 2019 THEN '10s'
		END AS decades,
		ROUND(AVG(so),1) AS avg_so,
		ROUND(AVG(hr),1) AS avg_hr
  			FROM batting
		WHERE yearid > 1919
		GROUP BY decades
  
	  
-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
	
	  SELECT playerid, SUM(sb) AS stole_base, SUM(cs) AS caught_stealing, CAST(sb AS float)/CAST(sb AS float)+CAST(cs AS float) AS tot
	  FROM batting
	  WHERE yearid = 2016 AND sb+cs >= 20
	  GROUP BY playerid
	  
-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
	
	SELECT name, max(w) AS wins, yearid
	FROM teams
	WHERE yearid between 1970 AND 2016 AND WSWin = 'N'
	GROUP BY name, yearid
	LIMIT 1
	
	SELECT name, min(w) AS wins
	FROM teams
	WHERE yearid between 1970 AND 2016 AND WSWin ='Y'
	GROUP BY name
	LIMIT 1

-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.


-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.


-- **Open-ended questions**

-- 11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

-- 12. In this question, you will explore the connection between number of wins and attendance.
--     <ol type="a">
--       <li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
--       <li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.</li>
--     </ol>


-- 13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?

  
