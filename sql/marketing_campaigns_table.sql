-- CTE to calculate number of signups per campaign
WITH signup_count AS (
    SELECT 
        customers.campaign_id, 
        COUNT(DISTINCT customers.customer_id) AS num_signups
    FROM 
        `psychic-raceway-393323.rowhealth.customers` customers 
    GROUP BY 
        customers.campaign_id
)

-- Main query to join campaigns with signup count and calculate additional metrics
-- Concatenating campaign details in a single column
-- Returning null for signup_rate, cost_per_signup, click_through_rate, and cost_per_click to avoid division by zero
SELECT 
    campaigns.campaign_id,
    campaigns.campaign_category,
    campaigns.campaign_type,
    campaigns.platform,
    CONCAT(
        campaigns.campaign_category, ' - ', 
        campaigns.campaign_type, ' - ',
        campaigns.platform
    ) AS campaign_detail,
    campaigns.days_run,
    campaigns.cost,
    campaigns.impressions,
    campaigns.clicks,
    signup_count.num_signups,
    CASE
        WHEN signup_count.num_signups = 0 THEN NULL 
        ELSE (signup_count.num_signups / campaigns.impressions)
    END AS signup_rate,
    CASE
        WHEN signup_count.num_signups = 0 THEN NULL
        ELSE (campaigns.cost / signup_count.num_signups)
    END AS cost_per_signup,
    CASE
        WHEN campaigns.impressions = 0 THEN NULL
        ELSE (campaigns.clicks / campaigns.impressions)
    END AS click_through_rate,
    CASE
        WHEN campaigns.clicks = 0 THEN NULL
        ELSE (campaigns.cost / campaigns.clicks)
    END AS cost_per_click
FROM 
    `psychic-raceway-393323.rowhealth.campaigns` campaigns 
LEFT JOIN 
    signup_count ON campaigns.campaign_id = signup_count.campaign_id
ORDER BY 
    campaigns.campaign_id
