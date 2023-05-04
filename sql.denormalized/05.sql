SELECT
    '#' || tag_1 AS tag,
    count(*) AS count
FROM (
    SELECT DISTINCT
        data->>'id' as id_tweets,
        jsonb_array_elements(
            COALESCE(data->'entities'->'hashtags','[]') ||
            COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]'))->>'text' AS tag_1
    FROM tweets_jsonb
    WHERE to_tsvector('english',COALESCE(data->'extended_tweet'->>'full_text',data->>'text')) @@ to_tsquery('english','coronavirus')
      AND data->>'lang'='en'
) t
GROUP BY tag
ORDER BY count DESC,tag
LIMIT 1000;