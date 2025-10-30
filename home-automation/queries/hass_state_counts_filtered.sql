SELECT
    states_meta.entity_id,
    COUNT(*) AS count,
    datetime(MIN(states.last_updated_ts), 'unixepoch') AS oldest_entry,
    datetime(MAX(states.last_updated_ts), 'unixepoch') AS newest_entry
FROM states
INNER JOIN states_meta ON states.metadata_id = states_meta.metadata_id
WHERE states_meta.entity_id LIKE '%' || $entity_pattern || '%'
GROUP BY states_meta.entity_id
ORDER BY count DESC
LIMIT 50;
