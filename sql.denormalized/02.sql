SELECT '#' || tag_1 AS tag, count(*) AS count
FROM (
    SELECT DISTINCT
    data->>'id' AS id_tweets,
    jsonb_array_elements(
        COALESCE(data->'entities'->'hashtags','[]') ||
        COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]'))->>'text' AS tag_1
        FROM tweets_jsonb
        WHERE data->'entities'->'hashtags' @@ '$[*].text == "coronavirus"'
          OR data->'extended_tweet'->'entities'->'hashtags' @@ '$[*].text == "coronavirus"') a
GROUP BY (1)
ORDER BY count DESC, tag
LIMIT 1000;