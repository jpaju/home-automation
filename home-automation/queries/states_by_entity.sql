SELECT
    states_meta.entity_id,
    states.state,
    datetime(states.last_updated_ts, 'unixepoch') AS last_updated
FROM states
INNER JOIN states_meta ON states.metadata_id = states_meta.metadata_id
WHERE states_meta.entity_id = $entity_id
ORDER BY states.last_updated_ts DESC
LIMIT 50;
