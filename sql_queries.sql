-- =====================================================
-- 1. TABLES
-- =====================================================

-- Create main table with basic match statistics

CREATE TABLE matches (
    season CHAR(64),
    played_matches INT,
    round CHAR(64),
    opponent CHAR(64),
    home_away CHAR(64),
    result_lit CHAR(64),
    result CHAR(64),
    goals_lit INT,
    goals_opponent INT,
    goals_difference INT,
    first_p_score CHAR(64),
    first_p_lit_goals INT,
    first_p_opp_goals INT,
    second_p_score CHAR(64),
    second_p_lit_goals INT,
    second_p_opp_goals INT,
    third_period_score CHAR(64),
    third_p_lit_goals INT,
    third_p_opp_goals INT,
    points_lit INT
);

-- Create scorer table in wide format

CREATE TABLE match_scorers (
    match_number INT,
    opponent VARCHAR(100),
    goal1_scorer VARCHAR(100),
    goal2_scorer VARCHAR(100),
    goal3_scorer VARCHAR(100),
    goal4_scorer VARCHAR(100),
    goal5_scorer VARCHAR(100),
    goal6_scorer VARCHAR(100),
    goal7_scorer VARCHAR(100),
    goal8_scorer VARCHAR(100)
);

-- Create scorer table in long format

CREATE TABLE goals_long (
    match_number INT,
    opponent VARCHAR(100),
    goal_number INT,
    scorer VARCHAR(100)
);


-- =====================================================
-- 2. VIEWS
-- =====================================================

-- Join main match table with scorer columns (wide format)

CREATE VIEW litvinov_matches_with_scorers AS
SELECT
    m.season,
    m.played_matches,
    m.round,
    m.opponent,
    m.home_away,
    m.result_lit,
    m.result,
    s.goal1_scorer,
    s.goal2_scorer,
    s.goal3_scorer,
    s.goal4_scorer,
    s.goal5_scorer,
    s.goal6_scorer,
    s.goal7_scorer,
    s.goal8_scorer
FROM matches AS m
LEFT JOIN match_scorers AS s
    ON m.played_matches = s.match_number
WHERE m.season = 'Sezóna 25/26';

-- Join main match table with long scorer table

CREATE VIEW long_table_matches AS
SELECT
    m.season,
    m.played_matches,
    m.round,
    m.opponent,
    m.home_away,
    m.result_lit,
    m.result,
    g.goal_number,
    g.scorer
FROM matches AS m
LEFT JOIN goals_long AS g
    ON m.played_matches = g.match_number
WHERE m.season = 'Sezóna 25/26';


-- =====================================================
-- 3. INSERT INTO LONG TABLE
-- =====================================================

-- Transform wide scorer table into long format

INSERT INTO goals_long (match_number, opponent, goal_number, scorer)
SELECT match_number, opponent, 1, goal1_scorer
FROM match_scorers
WHERE goal1_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 2, goal2_scorer
FROM match_scorers
WHERE goal2_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 3, goal3_scorer
FROM match_scorers
WHERE goal3_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 4, goal4_scorer
FROM match_scorers
WHERE goal4_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 5, goal5_scorer
FROM match_scorers
WHERE goal5_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 6, goal6_scorer
FROM match_scorers
WHERE goal6_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 7, goal7_scorer
FROM match_scorers
WHERE goal7_scorer IS NOT NULL

UNION ALL

SELECT match_number, opponent, 8, goal8_scorer
FROM match_scorers
WHERE goal8_scorer IS NOT NULL;


-- =====================================================
-- 4. EXAMPLE QUERIES
-- =====================================================

-- All matches against Sparta in wide format

SELECT *
FROM litvinov_matches_with_scorers
WHERE opponent = 'Sparta';

-- Scorers against Sparta in wide format

SELECT played_matches, opponent, goal1_scorer AS scorer
FROM litvinov_matches_with_scorers
WHERE opponent = 'Sparta'
  AND goal1_scorer IS NOT NULL

UNION ALL

SELECT played_matches, opponent, goal2_scorer
FROM litvinov_matches_with_scorers
WHERE opponent = 'Sparta'
  AND goal2_scorer IS NOT NULL

UNION ALL

SELECT played_matches, opponent, goal3_scorer
FROM litvinov_matches_with_scorers
WHERE opponent = 'Sparta'
  AND goal3_scorer IS NOT NULL;

-- All matches against Sparta in long format

SELECT *
FROM long_table_matches
WHERE opponent = 'Sparta'
ORDER BY played_matches, goal_number;


-- =====================================================
-- 5. SCORER ANALYSIS
-- =====================================================

-- Top scorers in season 25/26

SELECT
    scorer,
    COUNT(scorer) AS goals
FROM long_table_matches
WHERE scorer IS NOT NULL
GROUP BY scorer
ORDER BY goals DESC, scorer;


-- Goals scored against each opponent

SELECT
    opponent,
    COUNT(scorer) AS goals
FROM long_table_matches
WHERE scorer IS NOT NULL
GROUP BY opponent
ORDER BY goals DESC, opponent;

-- Who most often scores Litvínov's first goal in a match

SELECT
    g.scorer,
    COUNT(*) AS first_goals
FROM matches m
JOIN goals_long g
    ON m.played_matches = g.match_number
WHERE m.season = 'Sezóna 25/26'
  AND g.goal_number = 1
GROUP BY g.scorer
ORDER BY first_goals DESC, g.scorer;

-- Who most often opens scoring against each opponent

SELECT *
FROM (
    SELECT
        m.opponent,
        g.scorer,
        COUNT(*) AS first_goals,
        RANK() OVER (
            PARTITION BY m.opponent
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM matches m
    JOIN goals_long g
        ON m.played_matches = g.match_number
    WHERE m.season = 'Sezóna 25/26'
      AND g.goal_number = 1
    GROUP BY m.opponent, g.scorer
) t
WHERE rnk = 1
ORDER BY opponent;

-- Most productive Litvínov matches

SELECT
    m.played_matches,
    m.opponent,
    COUNT(*) AS goals
FROM matches m
JOIN goals_long g
    ON m.played_matches = g.match_number
WHERE m.season = 'Sezóna 25/26'
GROUP BY m.played_matches, m.opponent
ORDER BY goals DESC
LIMIT 2;

-- Which player scored against the highest number of different opponents

SELECT
    g.scorer,
    COUNT(DISTINCT m.opponent) AS teams_scored_against
FROM matches m
JOIN goals_long g
    ON m.played_matches = g.match_number
WHERE m.season = 'Sezóna 25/26'
GROUP BY g.scorer
ORDER BY teams_scored_against DESC;

-- Who scores the most goals at home vs away

SELECT
    m.home_away,
    g.scorer,
    COUNT(*) AS goals
FROM matches m
JOIN goals_long g
    ON m.played_matches = g.match_number
WHERE m.season = 'Sezóna 25/26'
GROUP BY m.home_away, g.scorer
ORDER BY m.home_away, goals DESC;

-- Ranking of scorers against each opponent

SELECT
    opponent,
    scorer,
    COUNT(scorer) AS goals,
    RANK() OVER (
        PARTITION BY opponent
        ORDER BY COUNT(scorer) DESC
    ) AS rnk
FROM long_table_matches
WHERE scorer IS NOT NULL
GROUP BY opponent, scorer
ORDER BY opponent, rnk, scorer;


-- =====================================================
-- 6. SEASON COMPARISON
-- =====================================================

-- Ranking seasons by total number of wins (including playoffs)

SELECT
    season,
    COUNT(*) AS wins_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS winning_rank
FROM matches
WHERE result IN ('V', 'VP')
GROUP BY season
ORDER BY winning_rank;

-- Ranking seasons by number of wins in regular season

SELECT
    season,
    COUNT(*) AS wins_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS winning_rank
FROM matches
WHERE result = 'V'
  AND round NOT IN ('baráž', 'playout', 'předkolo', 'čtvrtfinále', 'semifinále', 'finále')
GROUP BY season
ORDER BY winning_rank;

-- Ranking seasons by regular-season wins split into home vs away

SELECT
    season,
    home_away,
    COUNT(*) AS wins_count,
    RANK() OVER (
        PARTITION BY home_away
        ORDER BY COUNT(*) DESC
    ) AS winning_rank
FROM matches
WHERE result = 'V'
  AND round NOT IN ('baráž', 'playout', 'předkolo', 'čtvrtfinále', 'semifinále', 'finále')
  AND home_away NOT IN ('Open air Dresden')
GROUP BY season, home_away
ORDER BY home_away, winning_rank;

-- Ranking seasons by regular-season losses

SELECT
    season,
    COUNT(*) AS losses_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS losing_rank
FROM matches
WHERE result = 'P'
  AND round NOT IN ('baráž', 'playout', 'předkolo', 'čtvrtfinále', 'semifinále', 'finále')
GROUP BY season
ORDER BY losing_rank;

-- Ranking seasons by regular-season losses split into home vs away

SELECT
    season,
    home_away,
    COUNT(*) AS losses_count,
    RANK() OVER (
        PARTITION BY home_away
        ORDER BY COUNT(*) DESC
    ) AS losing_rank
FROM matches
WHERE result = 'P'
  AND round NOT IN ('baráž', 'playout', 'předkolo', 'čtvrtfinále', 'semifinále', 'finále')
  AND home_away NOT IN ('Open air Dresden')
GROUP BY season, home_away
ORDER BY home_away, losing_rank;
