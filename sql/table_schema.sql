DROP TABLE IF EXISTS raw_data;
CREATE TABLE raw_data(
	unixtime double precision NOT NULL,
	id bigint NOT NULL,
	x real NOT NULL,
	y real NOT NULL,
	z real NOT NULL,
	velocity real,
	direction real,
	acceleration real,
	ang_velocity real,
	category integer,
	grid_id text,
	area_id text,
	size int,
  flagment boolean DEFAULT 'false'
);

DROP INDEX IF EXISTS id_index;
CREATE INDEX id_index ON raw_data (id);

DROP TABLE IF EXISTS workspace;
CREATE TABLE workspace(
	id bigint NOT NULL,
	unixtime double precision NOT NULL,
	x real NOT NULL,
	y real NOT NULL
);

DROP INDEX IF EXISTS workspace_index;
CREATE INDEX workspace_index ON workspace (id);

DROP TABLE IF EXISTS time_range_info;
CREATE TABLE time_range_info(
	range_s timestamp,
	range_e timestamp,
	PRIMARY KEY(range_s, range_e)
);

DROP TABLE IF EXISTS time_range_count;
CREATE TABLE time_range_count(
	range_s timestamp,
	range_e timestamp,
	value integer NOT NULL
);

/*エリア集計関連*/
DROP TABLE IF EXISTS area_info;
CREATE TABLE area_info(
	area_name text PRIMARY KEY,
  vertex polygon NOT NULL
);

DROP TABLE IF EXISTS intrusion_list;
CREATE TABLE intrusion_list(
	intrusion_area text,
	id bigint,
	unixtime double precision,
	x real,
	y real,
	flagment boolean DEFAULT 'false'
);

DROP INDEX IF EXISTS intrusion_index;
CREATE INDEX intrusion_index ON intrusion_list (id);

DROP TABLE IF EXISTS workspace_intrusion;
CREATE TABLE workspace_intrusion(
	intrusion_area text,
	id bigint,
	unixtime double precision,
	x real,
	y real
);

DROP INDEX IF EXISTS workspace_intrusion_index;
CREATE INDEX workspace_intrusion_index ON workspace (id);

DROP TABLE IF EXISTS time_range_intrusion_count;
CREATE TABLE time_range_intrusion_count(
  area_name text,
	range_s timestamp,
	range_e timestamp,
  value integer NOT NULL
);

/*ライン集計関連*/
DROP TABLE IF EXISTS line_info;
CREATE TABLE line_info(
	line_name text PRIMARY KEY,
	sx REAL NOT NULL,
	sy REAL NOT NULL,
	ex REAL NOT NULL,
	ey REAL NOT NULL
);

DROP TABLE IF EXISTS intersect_list;
CREATE TABLE intersect_list(
	intersect_line text,
	id bigint,
	unixtime double precision,
	sx real,
	sy real,
	ex real,
	ey real,
	flagment boolean DEFAULT 'false'
);

DROP INDEX IF EXISTS intersect_index;
CREATE INDEX intersect_index ON intersect_list (id);

DROP TABLE IF EXISTS workspace_intersect;
CREATE TABLE workspace_intersect(
	intersect_line text,
	id bigint,
	unixtime double precision,
	sx real,
	sy real,
	ex real,
	ey real
);

DROP INDEX IF EXISTS workspace_intersect_index;
CREATE INDEX workspace_intersect_index ON workspace (id);

DROP TABLE IF EXISTS time_range_intersect_count;
CREATE TABLE time_range_intersect_count(
  line_name text,
	range_s timestamp,
	range_e timestamp,
  value integer NOT NULL
);
