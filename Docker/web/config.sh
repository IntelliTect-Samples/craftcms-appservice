
printf "CONFIG SCRIPT BEGIN"

ls -la

touch .env

original_string=$(cat <<- EOM
CRAFT_DB_DRIVER=[DB_DRIVER]
CRAFT_DB_SERVER=[DB_SERVER]
CRAFT_DB_PORT=[DB_PORT]
CRAFT_DB_DATABASE=[DB_DATABASE]
CRAFT_DB_USER=[DB_USER]
CRAFT_DB_USER_PASSWORD=[DB_PASSWORD]
CRAFT_DB_SCHEMA=[DB_SCHEMA]
CRAFT_DB_TABLE_PREFIX=[DB_TABLE_PREFIX]
PRIMARY_SITE_URL=[SITE_URL] 
EOM
)

modified_string="${original_string//'[DB_DRIVER]'/${CRAFT_DB_DRIVER}}"
modified_string="${modified_string//'[DB_SERVER]'/${CRAFT_DB_SERVER}}"
modified_string="${modified_string//'[DB_PORT]'/${CRAFT_DB_PORT}}"
modified_string="${modified_string//'[DB_DATABASE]'/${CRAFT_DB_DATABASE}}"
modified_string="${modified_string//'[DB_USER]'/${CRAFT_DB_USER}}"
modified_string="${modified_string//'[DB_PASSWORD]'/${CRAFT_DB_USER_PASSWORD}}"
modified_string="${modified_string//'[DB_SCHEMA]'/${CRAFT_DB_SCHEMA}}"
modified_string="${modified_string//'[DB_TABLE_PREFIX]'/${CRAFT_DB_TABLE_PREFIX}}"
modified_string="${modified_string//'[SITE_URL]'/${PRIMARY_SITE_URL}}"

echo "$modified_string" >> .env

ls -la
echo "file-content:"
cat .env

printf "CONFIG SCRIPT END"

