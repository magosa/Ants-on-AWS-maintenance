/*エリアの内外判定*/
DROP FUNCTION IF EXISTS extract_intrusion();
CREATE OR REPLACE FUNCTION extract_intrusion()
RETURNS void AS $$
DECLARE
  AREA_C CURSOR FOR
    SELECT * FROM area_info;
  AREA_CR RECORD;
BEGIN
DELETE FROM intrusion_list;
  OPEN AREA_C;
  LOOP
    FETCH AREA_C INTO AREA_CR;
    EXIT WHEN NOT FOUND;
    INSERT INTO intrusion_list SELECT AREA_CR.area_name, id, unixtime, x, y FROM raw_data
	  WHERE cast(cast(x AS text) ||','|| cast(y AS text) AS point) @  AREA_CR.vertex;
  END LOOP;
  CLOSE AREA_C;
END
$$ LANGUAGE plpgsql;


/*線分交差の判定と集計
 →処理時間に難あり
 →高速化の検討を行う*/
DROP FUNCTION IF EXISTS extract_intersect();
CREATE OR REPLACE FUNCTION extract_intersect()
RETURNS void AS $$
  DECLARE
    LINE_C CURSOR FOR
      SELECT * FROM line_info;
    LINE_CR RECORD;
  BEGIN
  DELETE FROM intersect_list;
    OPEN LINE_C;
    LOOP
      FETCH LINE_C INTO LINE_CR;
      EXIT WHEN NOT FOUND;
    	INSERT INTO intersect_list
      SELECT LINE_CR.line_name, t1.id, t2.unixtime AS just_after, t1.x AS sx, t1.y AS sy, t2.x AS ex, t2.y AS ey
      FROM (SELECT id, unixtime, x, y FROM raw_data
            WHERE (LINE_CR.sx - LINE_CR.ex) * (y - LINE_CR.sy) + (LINE_CR.sy - LINE_CR.ey) * (LINE_CR.sx - x) <= 0) AS t1
            INNER JOIN
              (SELECT id, unixtime, x, y FROM raw_data
              WHERE (LINE_CR.sx - LINE_CR.ex) * (y - LINE_CR.sy) + (LINE_CR.sy - LINE_CR.ey) * (LINE_CR.sx - x) > 0) AS t2
            ON t1.id = t2.id
            AND t1.unixtime < t2.unixtime
            AND t2.unixtime - t1.unixtime < 0.25
      WHERE (t1.x - t2.x) * (LINE_CR.sy - t1.y) + (t1.y - t2.y) * (t1.x - LINE_CR.sx) > 0
      AND (t1.x - t2.x) * (LINE_CR.ey - t1.y) + (t1.y - t2.y) * (t1.x - LINE_CR.ex) <= 0;
    END LOOP;
    CLOSE LINE_C;
  END;
$$ LANGUAGE plpgsql;

/*時間帯別の集計*/
DROP FUNCTION IF EXISTS culclate_time_range();
CREATE OR REPLACE FUNCTION culclate_time_range()
RETURNS void AS $$
DECLARE
  TIME_C CURSOR FOR
    SELECT * FROM time_range_info;
  TIME_CR RECORD;
BEGIN
  DELETE FROM time_range_count;
  DELETE FROM time_range_intrusion_count;
  DELETE FROM time_range_intersect_count;
  OPEN TIME_C;
  LOOP
    FETCH TIME_C INTO TIME_CR;
    EXIT WHEN NOT FOUND;
    INSERT INTO time_range_count (SELECT TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT id) FROM raw_data
	  WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e);

    INSERT INTO time_range_intrusion_count (SELECT list.intrusion_area, TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT list.id)
    FROM (SELECT intrusion_area, id FROM intrusion_list
      WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e
      GROUP BY intrusion_area, id) AS list
      GROUP BY list.intrusion_area);

    INSERT INTO time_range_intersect_count (SELECT list.intersect_line, TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT list.id)
    FROM (SELECT intersect_line, id FROM intersect_list
      WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e
    GROUP BY intersect_line, id) AS list
    GROUP BY list.intersect_line);
  END LOOP;
  CLOSE TIME_C;
END
$$ LANGUAGE plpgsql;


/*リアルタイムバッチ*/
DROP FUNCTION IF EXISTS timely_batch();

CREATE OR REPLACE FUNCTION timely_batch()
RETURNS void AS $$
DECLARE
  AREA_C CURSOR FOR
    SELECT * FROM area_info;
  AREA_CR RECORD;
  LINE_C CURSOR FOR
    SELECT * FROM line_info;
  LINE_CR RECORD;
  TIME_C CURSOR FOR
    SELECT * FROM time_range_info;
  TIME_CR RECORD;
BEGIN
  DELETE FROM workspace;
  DELETE FROM workspace_intrusion;
  DELETE FROM workspace_intersect;
  WITH updated AS (UPDATE raw_data SET flagment = true WHERE flagment = false RETURNING id, unixtime, x, y)
  INSERT INTO workspace SELECT * FROM updated;
  OPEN AREA_C;
  LOOP
    FETCH AREA_C INTO AREA_CR;
    EXIT WHEN NOT FOUND;
    INSERT INTO intrusion_list SELECT AREA_CR.area_name, id, unixtime, x, y FROM  workspace
	  WHERE cast(cast(x AS text) ||','|| cast(y AS text) AS point) @  AREA_CR.vertex;
  END LOOP;
  CLOSE AREA_C;
  OPEN LINE_C;
  LOOP
    FETCH LINE_C INTO LINE_CR;
    EXIT WHEN NOT FOUND;
    INSERT INTO intersect_list
    SELECT LINE_CR.line_name, t1.id, t2.unixtime AS just_after, t1.x AS sx, t1.y AS sy, t2.x AS ex, t2.y AS ey
    FROM (SELECT id, unixtime, x, y FROM workspace
          WHERE (LINE_CR.sx - LINE_CR.ex) * (y - LINE_CR.sy) + (LINE_CR.sy - LINE_CR.ey) * (LINE_CR.sx - x) <= 0) AS t1
          INNER JOIN
            (SELECT id, unixtime, x, y FROM workspace
            WHERE (LINE_CR.sx - LINE_CR.ex) * (y - LINE_CR.sy) + (LINE_CR.sy - LINE_CR.ey) * (LINE_CR.sx - x) > 0) AS t2
          ON t1.id = t2.id
          AND t1.unixtime < t2.unixtime
          AND t2.unixtime - t1.unixtime < 0.25
    WHERE (t1.x - t2.x) * (LINE_CR.sy - t1.y) + (t1.y - t2.y) * (t1.x - LINE_CR.sx) > 0
    AND (t1.x - t2.x) * (LINE_CR.ey - t1.y) + (t1.y - t2.y) * (t1.x - LINE_CR.ex) <= 0;
  END LOOP;
  CLOSE LINE_C;
  WITH updated_intrusion AS (UPDATE intrusion_list SET flagment = true WHERE flagment = false RETURNING intrusion_area, id, unixtime, x, y)
  INSERT INTO workspace_intrusion SELECT * FROM updated_intrusion;
  WITH updated_intersect AS (UPDATE intersect_list SET flagment = true WHERE flagment = false RETURNING intersect_line, id, unixtime, sx, sy, ex, ey)
  INSERT INTO workspace_intersect SELECT * FROM updated_intersect;
  OPEN TIME_C;
  LOOP
    FETCH TIME_C INTO TIME_CR;
    EXIT WHEN NOT FOUND;
    INSERT INTO time_range_count (SELECT TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT id) FROM workspace
	  WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e);
    INSERT INTO time_range_intrusion_count (SELECT list.intrusion_area, TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT list.id)
    FROM (SELECT intrusion_area, id FROM workspace_intrusion
      WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e
      GROUP BY intrusion_area, id) AS list
      GROUP BY list.intrusion_area);
    INSERT INTO time_range_intersect_count (SELECT list.intersect_line, TIME_CR.range_s, TIME_CR.range_e, COUNT(DISTINCT list.id)
    FROM (SELECT intersect_line, id FROM workspace_intersect
      WHERE TIME_CR.range_s <= to_timestamp(unixtime) AND to_timestamp(unixtime) < TIME_CR.range_e
    GROUP BY intersect_line, id) AS list
    GROUP BY list.intersect_line);
  END LOOP;
  CLOSE TIME_C;
END
$$ LANGUAGE plpgsql;
