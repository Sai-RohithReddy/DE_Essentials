CREATE DATABASE itversity_retail_db;

CREATE USER itversity_retail_user WITH ENCRYPTED PASSWORD 'root';

GRANT ALL ON DATABASE itversity_retail_db TO itversity_retail_user;

GRANT ALL ON SCHEMA PUBLIC TO itversity_retail_user;

ALTER DATABASE itversity_retail_db OWNER TO itversity_retail_user;