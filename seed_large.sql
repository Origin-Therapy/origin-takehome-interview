-- Bulk seed script: inserts 500 therapists, 500 patients, and 1,500 sessions with valid FKs.
-- Run with: psql "$DATABASE_URL" -f seed_large.sql
-- Tables/schema are expected to match db_schema_reference.sql.
-- Note: TRUNCATE resets IDs; comment it out if you need to keep existing data.

TRUNCATE sessions, patients, therapists RESTART IDENTITY CASCADE;

WITH
  therapist_first AS (
    SELECT ARRAY[
      'Anna','Marcus','Sofia','David','Emily','Rachel','James','Olivia','Michael','Sarah',
      'Christopher','Jessica','Daniel','Ashley','Matthew','Amanda','Joshua','Stephanie','Andrew','Nicole',
      'Ethan','Lauren','Grace','Justin','Natalie','Brian','Vanessa','Kevin','Theresa','Ian',
      'Lily','Caleb','Madison','Noah','Victoria','Samuel','Zoe','Logan','Caroline','Owen'
    ] AS names
  ),
  therapist_last AS (
    SELECT ARRAY[
      'Chen','Williams','Rodriguez','Kim','Johnson','Green','Wilson','Martinez','Brown','Davis',
      'Lee','Taylor','Anderson','Thomas','Jackson','White','Harris','Martin','Thompson','Garcia',
      'Bennett','Foster','Hayes','Mitchell','Rivera','Morgan','Reed','Phillips','Campbell','Torres',
      'Murphy','Brooks','Kelly','Price','Ross','Wood','Gray','James','Turner','Collins'
    ] AS names
  ),
  specialties AS (
    SELECT ARRAY[
      'Speech Therapy','Physical Therapy','Occupational Therapy'
    ] AS spec,
    ARRAY['SLP','PT','OT'] AS creds
  ),
  patient_first AS (
    SELECT ARRAY[
      'Liam','Emma','Noah','Olivia','Oliver','Ava','Elijah','Sophia','Lucas','Isabella',
      'Mason','Mia','Ethan','Charlotte','Aiden','Amelia','James','Harper','Benjamin','Evelyn',
      'Alexander','Abigail','Sebastian','Emily','Jack','Elizabeth','Henry','Sofia','Daniel','Avery',
      'Matthew','Ella','Jackson','Scarlett','David','Grace','Joseph','Chloe','Samuel','Victoria',
      'Owen','Penelope','Wyatt','Riley','Luke','Layla','Gabriel','Zoey','Isaac','Nora',
      'Jayden','Lily','Levi','Mila','Anthony','Aria','Dylan','Ellie','Lincoln','Aubrey',
      'Ryan','Hannah','Nathan','Addison','Caleb','Stella','Hunter','Bella','Christian','Maya',
      'Jonathan','Savannah','Jordan','Claire','Leo','Lucy','Aaron','Skylar','Thomas','Paisley',
      'Eli','Anna','Landon','Violet','Josiah','Hazel','Hudson','Aurora','Nicholas','Natalie'
    ] AS names
  ),
  patient_last AS (
    SELECT ARRAY[
      'Parker','Sullivan','Bennett','Foster','Hayes','Mitchell','Rivera','Morgan','Reed','Phillips',
      'Campbell','Torres','Murphy','Brooks','Kelly','Price','Ross','Wood','Gray','James',
      'Turner','Collins','Edwards','Miller','Peterson','Howard','Wright','Scott','King','Adams',
      'Nelson','Hill','Carter','Ramirez','Lewis','Robinson','Clark','Walker','Hall','Young',
      'Allen','Sanchez','Lopez','Gonzalez','Hernandez','Martinez','Moore','Taylor','Anderson','Thomas',
      'Jackson','White','Harris','Martin','Thompson','Garcia','Morris','Rogers','Cook','Bailey',
      'Cooper','Gray','Baker','Evans','Diaz','Nguyen','Cruz','Ortiz','Gomez','Murray'
    ] AS names
  ),
  inserted_therapists AS (
    INSERT INTO therapists (name, specialty)
    SELECT
      tf.names[(gs - 1) % array_length(tf.names, 1) + 1] || ' ' ||
      tl.names[((gs - 1) * 7) % array_length(tl.names, 1) + 1] || ', ' ||
      s.creds[(gs - 1) % array_length(s.spec, 1) + 1],
      s.spec[(gs - 1) % array_length(s.spec, 1) + 1]
    FROM generate_series(1, 500) AS gs
    CROSS JOIN therapist_first tf
    CROSS JOIN therapist_last tl
    CROSS JOIN specialties s
    RETURNING id
  ),
  inserted_patients AS (
    INSERT INTO patients (name, dob)
    SELECT
      pf.names[(gs - 1) % array_length(pf.names, 1) + 1] || ' ' ||
      pl.names[((gs - 1) * 7) % array_length(pl.names, 1) + 1],
      DATE '2013-01-01' + (floor(random() * 4000))::int  -- DOB between 2013 and ~2023 (ages ~2-12)
    FROM generate_series(1, 500) AS gs
    CROSS JOIN patient_first pf
    CROSS JOIN patient_last pl
    RETURNING id
  ),
  therapist_ids AS (
    SELECT array_agg(id) AS ids FROM inserted_therapists
  ),
  patient_ids AS (
    SELECT array_agg(id) AS ids FROM inserted_patients
  ),
  session_dates AS (
    SELECT
      (CURRENT_DATE - 30 + floor(random() * 120)::int)
        + (INTERVAL '8 hours' + (floor(random() * 10)::int * INTERVAL '1 hour'))
        + (CASE floor(random() * 4)::int
             WHEN 0 THEN INTERVAL '0 minutes'
             WHEN 1 THEN INTERVAL '15 minutes'
             WHEN 2 THEN INTERVAL '30 minutes'
             ELSE INTERVAL '45 minutes'
           END) AS session_date
    FROM generate_series(1, 1500)
  )
INSERT INTO sessions (therapist_id, patient_id, date, status)
SELECT
  t.ids[1 + floor(random() * array_length(t.ids, 1))::int],
  p.ids[1 + floor(random() * array_length(p.ids, 1))::int],
  d.session_date,
  CASE 
    WHEN d.session_date < CURRENT_DATE THEN
      -- Past sessions: mostly completed, some canceled/no show
      (ARRAY['Completed','Completed','Completed','Completed','Completed','Completed','Completed','Canceled','No Show','No Show'])[1 + floor(random() * 10)::int]
    ELSE
      -- Future sessions: mostly scheduled, few canceled
      (ARRAY['Scheduled','Scheduled','Scheduled','Scheduled','Scheduled','Scheduled','Scheduled','Scheduled','Scheduled','Canceled'])[1 + floor(random() * 10)::int]
  END
-- Cross join keeps random() volatile per session row so IDs aren't reused
FROM session_dates d
CROSS JOIN therapist_ids t
CROSS JOIN patient_ids p;
